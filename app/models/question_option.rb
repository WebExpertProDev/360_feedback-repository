class QuestionOption < ApplicationRecord
  belongs_to :question
  enum option_type: [:positive,:negative]

  # Globalize
  translates :full_text
end
