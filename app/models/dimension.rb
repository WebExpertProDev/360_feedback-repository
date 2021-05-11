class Dimension < ApplicationRecord
  belongs_to :questionnaire
  has_many :questions,dependent: :destroy

  has_many :submissions,through: :questions

  has_many :question_options,through: :questions,source: "options"

  # Globalize
  translates :name
end
