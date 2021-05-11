class LogbooksController < ApplicationController
	before_action :authenticate_user!
	before_action :set_leadership_survey, only: [:edit,:new,:update,:create]
	before_action :set_logbook, only: [:edit,:update]

	def show
		
	end

	def create
		@logbook = @leadership_survey.build_logbook(logbook_params)
		overview_7 = params.to_unsafe_h[:logbook][:overview_7].values.zip
		@logbook.overview_7 = overview_7
		@logbook.user = @leadership_survey.user
		if @logbook.save!
			redirect_to edit_leadership_survey_logbook_path(@leadership_survey,@logbook),notice: 'Saved!'
		else
			render :new
		end
		
	end

	def update
		# @logbook.user = @leadership_survey.user
		overview_7 = params.to_unsafe_h[:logbook][:overview_7].values.zip
		if @logbook.update!(logbook_params) && @logbook.update!(overview_7: overview_7)
			redirect_to edit_leadership_survey_logbook_path(@leadership_survey,@logbook),notice: 'Saved!'
		else
			render :edit
		end
		
	end

	def edit
	end

	def new
		@logbook = @leadership_survey.build_logbook
	end

	private

	def set_logbook
		@logbook = @leadership_survey.logbook
		
	end

	def set_leadership_survey
		@leadership_survey = LeadershipSurvey.friendly.find(params[:leadership_survey_id])
	end

	def logbook_params
        params.require(:logbook).permit(:id,
                :overview_1, 
                :overview_2, 
                :overview_3,
                :overview_4,
                :overview_5,
                :overview_6,
                :overview_8,
                :overview_7
        )
    end


end
