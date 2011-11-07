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

      can [:read], Comment
      can [:manage], Comment, :user_id => user.id
      can [:destroy], Comment, :plan => { :user_id => user.id } 
    end
  end
end
