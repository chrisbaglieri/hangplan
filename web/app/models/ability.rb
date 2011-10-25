class Ability
  include CanCan::Ability

  def initialize(user)
    if user
      can [:read], User
      can [:read, :create], Plan
      can [:update, :destroy], Plan, :owner => user
      can [:manage], Participant, :user => user
    end
  end
end
