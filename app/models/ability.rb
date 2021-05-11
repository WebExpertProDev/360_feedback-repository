# frozen_string_literal: true

# :Ability Class for managing authorizations:
class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user.admin?
      can :read, :all
      cannot :update, :all
      cannot :destroy, :all
      can :manage, :admin_panel
      can :manage, Variable
      can :manage, Questionnaire
      can :manage, Dimension
      can :manage, Question
    else
      cannot :manage, :all
    end
  end
end
