class LeadershipSurveysQuestionnaires < ActiveRecord::Migration[5.2]
  def change
  	create_table :leadership_surveys_questionnaires, :id => false do |t|
      t.integer :leadership_survey_id
      t.integer :questionnaire_id
    end
  end
end
