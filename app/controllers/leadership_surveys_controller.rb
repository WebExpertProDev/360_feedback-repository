class LeadershipSurveysController < ApplicationController
	before_action :authenticate_user,except: :leadership_survey
	def leadership_tests
		@tests = current_user.surveys.page(params[:page]).per(30)
	end
	
	def new
		@leadership_survey = LeadershipSurvey.new
		@leadership_survey.responses.build
	end

	def show
	end

	def create
		@leadership_survey = LeadershipSurvey.new(leadership_survey_params)
		# @leadership_survey.allquestions = Question.pluck(:id)
		@leadership_survey.user = current_user
		respond_to do |format|
			if @leadership_survey.save
				@response = @leadership_survey.responses.where(user: current_user).first
				format.js
				format.html { redirect_to edit_response_path(@response) }
			else
				format.js
				format.html {redirect_to request.referer, alert: @leadership_survey.errors.full_messages.to_sentence}

			end
		end
	end

	def summary
		@leadership_survey = LeadershipSurvey.includes(responses: [submissions: [:question, :question_statement]]).find(params[:leadership_survey_id])
		@self_response_submission = @leadership_survey.responses.self
		@other_response_submission = @leadership_survey.responses.where.not(user_type: 'self')
	end

	def leadership_survey
		@description = Variable.find_by_name("INTRODUCTION")&.description
		@test = LeadershipSurvey.friendly.find(params[:id])
		@questions = Question.where(id: @test&.allquestions).includes(:statements,:options)
	end
	def leadership_results
		@test = LeadershipSurvey.friendly.find(params[:id])
		@test.update(status: true)
	end
	def invite_user
		if params['email'].present?
			BasicMailer.send_invite(params['email'],params['test_id']).deliver_now
		end
		respond_to do |format|
			format.js {}
		end
	end
	def invitees

		@invitees = TestInvite.where(inviter_id: current_user.id,leadership_survey_id: params[:id]).includes(:invitee).pluck("users.email").uniq
		# @invitees = current_user.test_invites.where(leadership_survey_id: params[:id]).includes(:invitee).pluck("users.email").uniq
		respond_to do |format|
			format.js {}
			format.html
		end
	end

	def destroy
		# @div = "test_#{params[:id]}"
		@test = LeadershipSurvey.find(params[:id])
		@test.destroy
		redirect_to request.referer, notice: 'Assessment deleted successfully'
	end


	private

	def leadership_survey_params
		params.require(:leadership_survey).permit(:name,:user_id,:allquestions,:both_statements, :survey_type ,questionnaire_ids:[],responses_attributes: [:id,:_destroy,:user_id,:leadership_survey_id,:user_type])
	end
end