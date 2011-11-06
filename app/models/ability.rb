class Ability
  include CanCan::Ability

  def initialize(user)
    if user
      can [:read], User
      can [:manage], User, :id => user.id
      can [:read, :create], Plan
      can [:update, :destroy], Plan, :owner => user
      can [:manage], Participant, :user => user
      can [:read], :notifications
      can [:read, :create, :approve, :block, :remove], Friendship
    end
  end
end
