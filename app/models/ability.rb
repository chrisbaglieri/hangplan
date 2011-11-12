class Ability
  include CanCan::Ability

  def initialize(user)
    if user
      
      # a user can see another user
      # a user can only update their profile
      can [:read], User
      can [:manage], User, :id => user.id
      
      # a user can read a plan only if it's visible
      # a user can crete a plan
      # a user can update or destroy a plan that they own
      can [:read], Plan do |plan| plan.visible? user end
      can [:create], Plan
      can [:update, :destroy], Plan, :owner => user
      
      # a user can read a comment (for the plans they can access, implied)
      # a user can create a comment on visible plans
      # a user can update or destroy a comment they made
      # a user can destory any comment on their plan
      can [:read], Comment
      can [:create], Comment do |comment| comment.plan.visible? user end
      can [:update, :destroy], Comment, :user => user
      can [:destroy], Comment, :plan => { :user_id => user.id }
      
      # a user can become a participant on visible plans
      # a user can update or destroy their participation
      can [:create], Participant do |participant| participant.plan.visible? user end
      can [:update, :destroy], Participant, :user => user
      
      # a user can read their notifications
      can [:read], :notifications
      
      # a user can see their friends and create new ones
      # a user can manage friendships they belong to (managed in controller)
      can [:read, :create], Friendship
      can [:approve, :remove], Friendship
      
    end
  end
end
