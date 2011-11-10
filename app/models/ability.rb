class Ability
  include CanCan::Ability

  def initialize(user)
    if user
      
      # a user can see another user
      can [:read], User
      
      # a user can only update their profile
      can [:manage], User, :id => user.id
      
      # a user can read a plan if they own it OR
      # a user can read a plan if they're invited OR
      # a user can read a plan if they're a friend of the owner and it's not invite only
      can [:read], Plan do |plan|
        plan.owner == user or plan.invited?(user) or (user.friends.include? plan.owner and !plan.invite_only)
      end
      
      # a user can crete a plan
      can [:create], Plan
      
      # a user can update or destroy a plan that they own
      can [:update, :destroy], Plan, :owner => user
      
      # a user can read a comment (for the plans they can access)
      can [:read], Comment
      
      # a user can manage a comment that they made
      can [:manage], Comment, :user_id => user.id
      
      # a user can destory any comment on their plan
      can [:destroy], Comment, :plan => { :user_id => user.id }
      
      # a user can manage themselves as a participant
      can [:manage], Participant, :user => user
      
      # a user can read their notifications
      can [:read], :notifications
      
      # a user can see their friends and create new ones
      can [:read, :create], Friendship
      
      # a user can manage friendships they belong to (managed in controller)
      can [:approve, :remove], Friendship
      
    end
  end
end
