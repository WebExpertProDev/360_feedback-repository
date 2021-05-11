class AddSurveyTypeToLeadershipSurveys < ActiveRecord::Migration[5.2]
  def change
    add_column :leadership_surveys, :survey_type, :integer
  end
end
