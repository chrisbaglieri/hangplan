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
      can [:destroy], Comment, :user => user

      can [:read, :create], Comment do |comment|
        comment.plan.participant?(user)
      end 
      
      can [:manage], Comment do |comment| 
        comment.plan.owner?(user)
      end 
      
    end
  end
end
