class Variable < ApplicationRecord
  def self.behavior_assessment_payment_amount
    Variable.find_by_name('Behavior_Assessment_Price').value * 100
  end

  def self.challenge_assessment_payment_amount
    Variable.find_by_name('Challenge_Assessment_Price').value * 100
  end
end
