class Logbook < ApplicationRecord
  belongs_to :user
  belongs_to :leadership_survey
  serialize :overview_7,Array
end
