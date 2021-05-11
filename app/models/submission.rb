class Submission < ApplicationRecord
  belongs_to :response
  belongs_to :question
  belongs_to :question_statement,optional: true

  after_create :calculate_scaled_score
  after_update :calculate_scaled_score,:if => :saved_change_to_semantic_score?

  SCORE_DESC = {
  	1 => 'Seldom',
  	2 => 'Sometimes',
  	3 => 'Regularly',
  	4 => 'Frequent',
  	5 => 'Often',
  	6 => 'Very Often'
  }

  # Never Seldom  Sometimes Regular Frequently  Often Very Often  Almost Always

  BEHAVIOUR_SCORE_DESC = {
    1 => 'Never',
    2 => 'Seldom',
    3 => 'Sometimes',
    4 => 'Regular',
    5 => 'Frequently',
    6 => 'Often',
    7 => 'Very Often',
    8 => 'Almost Always'
  }

  def calculate_scaled_score
    # third questionnaire is behaviour
    unless question.questionnaire.id == Questionnaire.third.id
      # make it in range  1,2,3,4,5,6,7,8
  	 update!(scaled_score: semantic_score + (semantic_score < 0 ? 5:4)) if semantic_score
    else
      update!(scaled_score: semantic_score) if semantic_score
    end
    # raise semantic_score
  end

  def self.user_type_and_score_wise_distribution(question_id,survey_id,statement_type)
  	Submission.joins(:question_statement,:question,response: [:leadership_survey]).where("leadership_surveys.id" => survey_id,"question_statements.statement_type" => statement_type,"questions.id"=>question_id).group('responses.user_type',:scaled_score).count

  end
end
