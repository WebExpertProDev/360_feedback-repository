class TestInvite < ApplicationRecord
  belongs_to :test, class_name: "LeadershipSurvey", foreign_key: "leadership_survey_id"
  belongs_to :inviter,class_name: "User"
  belongs_to :invitee,class_name: "User"
end
