class LeadershipSurvey < ApplicationRecord
	belongs_to :user
	has_many :invites,class_name: "TestInvite",dependent: :destroy
	extend FriendlyId
	friendly_id :generated_slug, use: :slugged
	enum survey_type: [:challenges, :behaviour]


	has_many :responses,dependent: :destroy
	has_many :submissions, through: :responses

	has_many :peer_responses, -> (object) { where.not(user_type: "self",user_id: object.user.id) },class_name: "Response"
	has_many :peer_submissions, through: :peer_responses,source: :submissions

	has_many :owner_responses, -> (object) { where(user_type: "self",user_id: object.user.id) },class_name: "Response"
	has_many :owner_submissions, through: :owner_responses,source: :submissions



	has_and_belongs_to_many :questionnaires,dependent: :destroy
	accepts_nested_attributes_for :responses, allow_destroy: true

	has_one :logbook, dependent: :destroy

	attr_accessor :questionnaire_check_box

	after_create :assign_questionnaires, :update_user_balance


	def update_user_balance
		return if user.corporate_user? && user.surveys.count < 1

		if survey_type == 'challenges'
			user.update(balance_cents: user.balance_cents - Variable.challenge_assessment_payment_amount)
		else
			user.update(balance_cents: user.balance_cents - Variable.behavior_assessment_payment_amount)
		end
	end

	def assign_questionnaires
		if challenges?
			Questionnaire.first(2).each do |q|
				self.questionnaires << q
			end
		elsif behaviour?
			Questionnaire.last(2).each do |q|
				self.questionnaires << q
			end
		end
	end

	def dimension_wise_average(questionnaire_id,statement_type,user_type)
		res = submissions.joins([:response,:question_statement,question: :dimension]).where(responses: {user_type: user_type},question_statements: {statement_type: statement_type},questions: {questionnaire_id: questionnaire_id }).group([:dimension_id]).average(:semantic_score)
		questionnaire = Questionnaire.find(questionnaire_id)
		questionnaire_dimensions = questionnaire.dimensions
		dimension_hash = {}
		questionnaire_dimensions.each do |d|
			dimension_hash[d.name] = res[d.id].present? ? res[d.id]:0 
		end
		dimension_hash
	end

	def question_wise_average(questionnaire_id,statement_type,user_type)
		submissions.joins([:response,:question_statement,question: :dimension]).where(responses: {user_type: user_type},question_statements: {statement_type: statement_type},questions: {questionnaire_id: questionnaire_id }).group([:question_id]).average(:scaled_score)
	end

	def mindset_meter(questionnaire_id,user_type)
		submissions.joins([:response,:question_statement,question: :dimension]).where(responses: {user_type: user_type},question_statements: {statement_type: 'standard'},questions: {questionnaire_id: questionnaire_id }).average(:semantic_score)
	end

	def swot_analysis(questionnaire_id,statement_type)

		# my - other < 2 -- Acknowledged talents
		# Acknowledged development points

		# other - my >= 2 -- Hidden talents
		# my -other >=2 -- Blind spots
		myself = question_wise_average(questionnaire_id,statement_type,'self')
		others = question_wise_average(questionnaire_id,statement_type,['peer','direct_report','supervisor','stakeholder'])
		result = {}

		# Acknowledged talents
		criteria_filter = myself.reject {|k,v| v <= 3 }
		difference = {}
		criteria_filter.each do |k,v|
			if others[k].present?
				difference[k] = criteria_filter[k] - others[k]
			end
		end
		result[:difference_ack_talents] = difference

		difference_criteria = difference.select { |k,v| v < 3 }
		difference_criteria = difference_criteria.sort_by { |k,v| v }
		difference_criteria = difference_criteria.first(5).to_h
		# p difference_criteria

		ack_talents = difference_criteria.keys

		# Acknowledged Developemntal talents
		criteria_filter_myself = myself.reject {|k,v| v >= 4 }
		criteria_filter_others = others.reject {|k,v| v >= 4 }
		# p criteria_filter,myself,myself.values.map(&:to_f)
		difference = {}
		criteria_filter_myself.each do |k,v|
			if criteria_filter_others[k].present?
				difference[k] = criteria_filter_myself[k] - criteria_filter_others[k]
			end
		end
		result[:difference_ack_dev_talents] = difference


		difference_criteria = difference.select { |k,v| v < 3 }
		difference_criteria = difference_criteria.sort_by { |k,v| v }.first(5).to_h
		ack_dev_talents = difference_criteria.keys
		


		# hidden talents
		criteria_filter_myself = myself.reject {|k,v| v >= 4 }
		criteria_filter_others = others.reject {|k,v| v <= 3 }
		p criteria_filter_myself,criteria_filter_others
		difference = {}
		criteria_filter_others.each do |k,v|
			if criteria_filter_myself[k].present?
				difference[k] = criteria_filter_others[k] - criteria_filter_myself[k]
			end
		end

		result[:difference_hidden_talents] = difference



		difference_criteria = difference.select { |k,v| v > 3 }
		difference_criteria = difference_criteria.sort_by { |k,v| v }.last(5).to_h
		hidden_talents = difference_criteria.keys



		# Blind spots
		criteria_filter_myself = myself.select {|k,v| v >= 4 }
		criteria_filter_others = others.select {|k,v| v <= 3 }
		# p criteria_filter_myself,criteria_filter_others
		difference = {}
		criteria_filter_myself.each do |k,v|
			if criteria_filter_others[k].present?
				difference[k] = criteria_filter_myself[k] - criteria_filter_others[k]
			end
		end

		result[:difference_blind_spots] = difference


		difference_criteria = difference.select { |k,v| v > 3 }
		difference_criteria = difference_criteria.sort_by { |k,v| v }.last(5).to_h
		blind_spots = difference_criteria.keys








		# result = {}

		result[:ack_talents] = Question.where(id: ack_talents).collect {|q| q.options.first.full_text }
		result[:ack_dev_talents] = Question.where(id: ack_dev_talents).collect {|q| q.options.first.full_text }
		result[:hidden_talents] = Question.where(id: hidden_talents).collect {|q| q.options.first.full_text }
		result[:blind_spots] = Question.where(id: blind_spots).collect {|q| q.options.first.full_text }
		result



	end

	def top_3_strength(questionnaire_id,statement_type)
		res = peer_submissions.joins([:question,:question_statement]).where(questions: {questionnaire_id: questionnaire_id },question_statements: {statement_type: statement_type}).group([:question_id]).average(:scaled_score).sort_by{|k,v| v}

		standard = res.last(3)
		dev = res.first(3)

		result = {}
		result[:res] = res
		unless standard.empty?
			ques_ids = standard.to_h.keys
			ques = Question.find(ques_ids)
			result[:standard] =  ques.collect{|q| q.options.first.full_text }
		end
		unless dev.empty?
			ques_ids = dev.to_h.keys
			ques = Question.find(ques_ids)
			result[:dev] = ques.collect{|q| q.options.first.full_text }
		end
		return result
	end

	
	def generated_slug
		@random_slug ||= persisted? ? friendly_id : ('a'..'z').to_a.shuffle[0,5].join + (1..9).to_a.shuffle[0,7].join 
	end

	def peer_leadership_questions_average
		# For standard statements
		leadership_questionnaire = Questionnaire.first
		questions_ids = leadership_questionnaire.questions.pluck(:id)
		statement1 = leadership_questionnaire.questions.collect{|q| q.statements.standard.first&.id }

		if leadership_questionnaire.present?
			peer_submissions.where(question_id: questions_ids,question_statement_id: statement1).group([:question_id,:question_statement_id]).average(:semantic_score).sort_by{|k,v| v }

		end
	end

	def survey_self_score
	end

	# def survey_average_sco

	def peer_dimension_average
		dimension_hash = {}
		d = Dimension.pluck(:id)
		d.each{|dd| dimension_hash[dd] = {} }
		peer_leadership_questions_average.each do |a|
			question = Question.find(a.first.first)
			dimension_hash[question.dimension.id][question.id] = a.second

		end
		dimension_hash.each { |k,v| dimension_hash[k] = v.values.sum/v.values.size rescue -1000 }
	end

	def hidden_talent
		leadership_questionnaire = Questionnaire.first
		questions_ids = leadership_questionnaire.questions.pluck(:id)
		statement1 = leadership_questionnaire.questions.collect{|q| q.statements.standard.first&.id }

		o_s = owner_submissions.where(question_id: questions_ids,question_statement_id: statement1).group([:question_id,:question_statement_id]).average(:semantic_score).sort_by{|k,v| v }





		peer = Hash[peer_leadership_questions_average.collect { |k,v| [k.first, v] }]
		self_response = Hash[o_s.collect { |k,v| [k.first, v] }]
		
		# self_response = Hash[owner_submissions.where(question_statement_id: nil).collect { |e| [e.question_id, e.semantic_score] }]
		# p self_response, peer


		result = {}
		peer.each { |k,v| result[k] = peer[k] - self_response[k] }
		result.reject!{|k,v| v < 2 }
		result = result.sort_by {|key, value| value }.to_h
		result = result.first(5).to_h
		


		# peer.keys.collect{|e| Question.find(e).options.positive.first.full_text if peer[e] - self_response[e] >=2 }.compact
		
		result.keys.collect{|e| Question.find(e).options.positive.first.full_text if peer[e] - self_response[e] >=2 }.compact

	end

	def acknowledged_talents

		leadership_questionnaire = Questionnaire.first
		questions_ids = leadership_questionnaire.questions.pluck(:id)
		statement1 = leadership_questionnaire.questions.collect{|q| q.statements.standard.first&.id }

		o_s = owner_submissions.where(question_id: questions_ids,question_statement_id: statement1).group([:question_id,:question_statement_id]).average(:semantic_score).sort_by{|k,v| v }

		peer = Hash[peer_leadership_questions_average.collect { |k,v| [k.first, v] }]
		self_response = Hash[o_s.collect { |k,v| [k.first, v] }]


		result = {}
		peer.each { |k,v| result[k] = peer[k] - self_response[k] }
		result.reject!{|k,v| v >= 2 }
		result = result.sort_by {|key, value| value }.to_h
		result = result.first(5).to_h
		







		# peer = Hash[peer_leadership_questions_average.collect { |k,v| [k.first, v] }]
		# self_response = Hash[owner_submissions.where.not(question_statement_id: nil).collect { |e| [e.question_id, e.semantic_score] }]
		# p self_response, peer
		# ack = peer.keys.collect{|e| Question.find(e).options.positive.first.full_text if peer[e] - self_response[e] < 2 }.compact
		ack = result.keys.collect{|e| Question.find(e).options.positive.first.full_text if peer[e] - self_response[e] < 2 }.compact
		# raise 
	end

	def acknowledged_development_points

		leadership_questionnaire = Questionnaire.first
		questions_ids = leadership_questionnaire.questions.pluck(:id)
		statement1 = leadership_questionnaire.questions.collect{|q| q.statements.standard.first&.id }

		o_s = owner_submissions.where(question_id: questions_ids,question_statement_id: statement1).group([:question_id,:question_statement_id]).average(:semantic_score).sort_by{|k,v| v }

		peer = Hash[peer_leadership_questions_average.collect { |k,v| [k.first, v] }]
		self_response = Hash[o_s.collect { |k,v| [k.first, v] }]


		result = {}
		peer.each { |k,v| result[k] = self_response[k] - peer[k] }
		result.reject!{|k,v| v >= 2 }
		result = result.sort_by {|key, value| value }.to_h
		result = result.first(5).to_h



		




		# peer = Hash[peer_leadership_questions_average.collect { |k,v| [k.first, v] }]
		# self_response = Hash[owner_submissions.where.not(question_statement_id: nil).collect { |e| [e.question_id, e.semantic_score] }]


		# peer.keys.collect{|e| Question.find(e).options.negative.first.full_text if self_response[e] - peer[e] < 2 }.compact
		result.keys.collect{|e| Question.find(e).options.negative.first.full_text if self_response[e] - peer[e] < 2 }.compact

	end

	def blind_spots

		leadership_questionnaire = Questionnaire.first
		questions_ids = leadership_questionnaire.questions.pluck(:id)
		statement1 = leadership_questionnaire.questions.collect{|q| q.statements.standard.first&.id }

		o_s = owner_submissions.where(question_id: questions_ids,question_statement_id: statement1).group([:question_id,:question_statement_id]).average(:semantic_score).sort_by{|k,v| v }

		peer = Hash[peer_leadership_questions_average.collect { |k,v| [k.first, v] }]
		self_response = Hash[o_s.collect { |k,v| [k.first, v] }]

		result = {}
		peer.each { |k,v| result[k] = self_response[k] - peer[k] }
		result.reject!{|k,v| v < 2 }
		result = result.sort_by {|key, value| value }.to_h
		result = result.first(5).to_h
		
		





		
		# peer = Hash[peer_leadership_questions_average.collect { |k,v| [k.first, v] }]
		# self_response = Hash[owner_submissions.where.not(question_statement_id: nil).collect { |e| [e.question_id, e.semantic_score] }]


		# peer.keys.collect{|e| Question.find(e).options.negative.first.full_text if self_response[e] - peer[e] >=2 }.compact
		result.keys.collect{|e| Question.find(e).options.negative.first.full_text if self_response[e] - peer[e] >=2 }.compact

	end

	


	def average_of_question
		responses.where.not(user_type: "self")

	end



end
