class SubmissionsController < ApplicationController
	before_action :authenticate_user!
	before_action :set_response,except: [:new,:create,:results]
	before_action :set_leadership_survey,only: [:new,:create]

	def new
		@response = @leadership_survey.responses.new(user: current_user)
		
	end

	def create
		@response = @leadership_survey.responses.new(response_params)
		@response.user = current_user
		if @response.save
			redirect_to edit_response_path(@response)
		else
			redirect_to request.referer,alert: @response.errors.full_messages.to_sentence
		end

	end


	def results


		@response = Response.find(params[:response_id])
		@leadership_survey = @response.leadership_survey
		@user_types = Response.user_types

		if @leadership_survey.challenges?
			leadership_survey_average = @leadership_survey.peer_leadership_questions_average

			top3_question_ids = leadership_survey_average.last(3).collect {
			  | a | a.first.first
			}
			top3_questions = Question.where(id: top3_question_ids)
			@top3_questions_positive_options = top3_questions.collect {
			  | q | q.options.positive.first.full_text
			}.flatten

			last3_question_ids = leadership_survey_average.first(3).collect {
			  | a | a.first.first
			}
			last3_questions = Question.where(id: last3_question_ids)
			@last3_questions_negative_options = last3_questions.collect {
			  | q | q.options.negative.first.full_text
			}.flatten


			@swot_analysis = @leadership_survey.swot_analysis(1,'standard')



			@hidden_talents = @leadership_survey.hidden_talent
			@blind_spots = @leadership_survey.blind_spots

			@ack_points = @leadership_survey.acknowledged_talents
			@ack_dev_points = @leadership_survey.acknowledged_development_points

			leadership_dimensions = Questionnaire.first.dimensions.collect{|d| [d.id, d.name] }

			datasets = GraphPresenter.new(
			  ResponseTypeDimensionSummary.new(
			    query_params(
			      @leadership_survey.id,
			      "standard",
			      leadership_questionnaire
			    )
			  ),
			  Response.user_types.keys

			).datasets[:bar]

			# LEADERSHIP
			dev_data_summary = ResponseTypeDimensionSummary.new(
			  query_params(
			    @leadership_survey.id,
			    "development",
			    leadership_questionnaire
			  )
			).call("supervisor").with_all_dimensions

			datasets << {
			  data: dev_data_summary.values,
			  label: 'Developmental - Supervisor',
			  #backgroundColor: color[index]
			  backgroundColor: '#007584'
			}

			dev_data_summary_other = ResponseTypeDimensionSummary.new(
			  query_params(
			    @leadership_survey.id,
			    "development",
			    leadership_questionnaire
			  )
			).call(['peer', 'direct_report', 'stakeholder']).with_all_dimensions

			datasets << {
			  data: dev_data_summary_other.values,
			  label: 'Developmental - Others',
			  #backgroundColor: color[index]
			  backgroundColor: '#5db6c1',
			  datalabels: {
			    display: false
			  }
			}#
			@graph_object = {
			  labels: leadership_dimensions.to_h.values.map(&:split),
			  datasets: datasets
			}

			@questionnaires = @leadership_survey.questionnaires.includes(dimensions: [:question_options])

			
		elsif @leadership_survey.behaviour?
			@self = @leadership_survey.dimension_wise_average(3,'standard','self')
			@questionnaires = @leadership_survey.questionnaires

			@circle_datasets = GraphPresenter.new(
				ResponseTypeDimensionSummary.new(
						query_params(
							@leadership_survey.id,
							"standard",
							Questionnaire.third
						)
				),
				Response.user_types.keys

			).polar_graph

			@swot_analysis = @leadership_survey.swot_analysis(3,'standard')






			dev_data_summary = ResponseTypeDimensionSummary.new(
			  query_params(
			    @leadership_survey.id,
			    "development",
			    Questionnaire.third
			  )
			).call("supervisor").with_all_dimensions
			@circle_datasets['Developmental - Supervisor'] = dev_data_summary

			
			dev_data_summary_other = ResponseTypeDimensionSummary.new(
			  query_params(
			    @leadership_survey.id,
			    "development",
			    Questionnaire.third
			  )
			).call(['peer', 'direct_report', 'stakeholder']).with_all_dimensions
			@circle_datasets['Developmental - Others'] = dev_data_summary

			
















			@top_3_strength = @leadership_survey.top_3_strength(3,'standard')
			# raise


			# Mindset
		end




		######## MINDSET  ##################

		mindset_dimensions = Questionnaire.second.dimensions.collect{ |d| [d.id,d.name] }

		datasets_hash_mindset = GraphPresenter.new(
		  ResponseTypeDimensionSummary.new(
		    query_params(
		      @leadership_survey.id,
		      "standard",
		      mindset_questionnaire
		    )
		  ),
		  Response.user_types.keys

		).datasets
		@gauge_dials = datasets_hash_mindset[:gauge_dials]
		# raise

		# MINDSET
		datasets_mindset = datasets_hash_mindset[:bar]

		dev_data_summary_mindset = ResponseTypeDimensionSummary.new(
		  query_params(
		    @leadership_survey.id,
		    "development",
		    mindset_questionnaire
		  )
		).call("supervisor").with_all_dimensions

		datasets_mindset << {
		  data: dev_data_summary_mindset.values,
		  label: 'Developmental - Supervisor',
		  #backgroundColor: color[index]
		  backgroundColor: '#007584'
		}

		dev_data_summary_other_mindset = ResponseTypeDimensionSummary.new(
		  query_params(
		    @leadership_survey.id,
		    "development",
		    mindset_questionnaire
		  )
		).call(['peer', 'direct_report', 'stakeholder']).with_all_dimensions

		datasets_mindset << {
		  data: dev_data_summary_other_mindset.values,
		  label: 'Developmental - Others',
		  #backgroundColor: color[index]
		  backgroundColor: '#5db6c1'
		}

		@graph_object_mindset = {
		  labels: mindset_dimensions.to_h.values,
		  datasets: datasets_mindset
		}
		@mindset_positve_options = QuestionOption.joins(:question).where("questions.questionnaire_id" => 2, "question_options.option_type" => "positive")

		
	end

	def edit
		unless @response.completed
			@questionnaires = @response.leadership_survey.questionnaires
			@questionnaires.each do |qq|
				qq.questions.each do |q|
					if q.statements.present?
						if @response.leadership_survey.both_statements
							q.statements.each do |s|
								@response.submissions.build(question_id: q.id,question_statement_id: s.id)
							end
							aa = @response.submissions.group_by {|rq| rq.question }
						else
							@response.submissions.build(question_id: q.id,question_statement_id: q.statements.first.id)
						end
					else
						@response.submissions.build(question_id: q.id)
					end

				end
			end
		end
	end

	def update
		respond_to do |format|
			if @response.update(response_params)
				if @response.user_type != 'self'
					if @response.leadership_survey.invites.present?
						invites = @response.leadership_survey.invites.select(:invitee_id, :inviter_id)
						invites.each do |invite|
							if current_user.id == invite.invitee_id
								BasicMailer.send_email_to_inviter(invite.inviter_id, invite.invitee_id).deliver_now
							end
						end
					end
				end
				# format.html { redirect_to response_results_path(@response), notice: "Response has been saved" }
				format.html { redirect_to user_tests_path, notice: "Response has been saved" }
			else
				format.html {redirect_to request.referer, notice: @response.errors.full_messages.to_sentence}
			end
		end
		# @response.update
	end

	private

	def set_leadership_survey
		@leadership_survey = LeadershipSurvey.friendly.find(params[:leadership_survey_id])
	end

	def set_response
		@response = Response.find(params[:id])
	end

	def response_params
		params.require(:response).permit(:completed,:user_type,submissions_attributes: [:id,:_destroy,:semantic_score,:question_id,:question_statement_id])

		
	end
	def query_params(survey_id,statement_type,questionnaire_id)
		{
			survey_id: survey_id,
			statement_type:  statement_type,
			questionnaire: questionnaire_id
		}
	end

	def leadership_questionnaire
		Questionnaire.first
	end

	def mindset_questionnaire
		Questionnaire.second
	end
end
