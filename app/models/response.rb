class Response < ApplicationRecord
	enum user_type: [:self,:peer,:direct_report,:supervisor,:stakeholder]
	belongs_to :leadership_survey
	belongs_to :user

	has_many :submissions,dependent: :destroy
	accepts_nested_attributes_for :submissions, allow_destroy: true


	def average_score
	end
end
