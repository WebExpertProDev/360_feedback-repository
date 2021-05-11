class AddLeadershipSurveyIdToLogbooks < ActiveRecord::Migration[5.2]
  def change
  	add_reference :logbooks, :leadership_survey, index: true
  end
end
