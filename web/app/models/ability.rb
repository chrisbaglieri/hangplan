class Ability
  include CanCan::Ability

  def initialize(user)
    can [:read], Plan
    if user
      can [:manage], Participant
      can [:read, :create], Plan
      can [:update, :destroy], Plan, :owner => user
      can [:manage], Subscription
    end
  end
end
