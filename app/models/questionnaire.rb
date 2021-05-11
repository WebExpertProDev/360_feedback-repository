# frozen_string_literal: true

# :Questionnarie Class for handling Associations and Settings:
class Questionnaire < ApplicationRecord
  has_many :dimensions, dependent: :destroy
  # has_and_belongs_to_many :questionnaires

  has_many :questions, dependent: :destroy

  # Globalize
  translates :name, :intro_text
end
