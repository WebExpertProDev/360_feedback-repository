class Question < ApplicationRecord
  belongs_to :questionnaire
  belongs_to :dimension
  has_many :statements,class_name: "QuestionStatement",dependent: :destroy
  has_many :options,class_name: "QuestionOption",dependent: :destroy

  has_many :submissions,dependent: :destroy

  # after_save :create_children

  accepts_nested_attributes_for :statements, allow_destroy: true,reject_if: proc { |attributes| attributes['full_text'].blank? }
  accepts_nested_attributes_for :options, allow_destroy: true,reject_if: proc { |attributes| attributes['full_text'].blank? }


  # attr_accessor :statements_arr,:options_arr

  # def create_children
  # 	if self.statements_arr.present? and self.questionnaire.name != "Mindset"
  #     self.statements.destroy_all
  # 		self.statements_arr.each do |statement|
  # 			QuestionStatement.create!(question_id: self.id,full_text: statement) if statement.present?
  # 		end
  # 	end

  # 	if self.options_arr.present?
  #     self.options.destroy_all
  # 		self.options_arr.each do |option|
  # 			QuestionOption.create!(question_id: self.id,full_text: option)
  # 		end
  # 	end
  # end
  
end
