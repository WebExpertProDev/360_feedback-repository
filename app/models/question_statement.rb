class QuestionStatement < ApplicationRecord
  belongs_to :question
  has_many :submissions,dependent: :destroy

  enum statement_type: [:standard,:development]

  # Globalize
  translates :full_text
end
