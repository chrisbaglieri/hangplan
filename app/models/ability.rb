class Ability
  include CanCan::Ability

  def initialize(user)
    if user
      can [:read, :create], Plan
      can [:update, :destroy], Plan, :owner => user
    end
  end
end
