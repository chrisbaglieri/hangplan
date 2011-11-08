require 'spec_helper'
require 'cancan/matchers'

describe Comment do

  it { should belong_to(:user) }
  it { should belong_to(:plan) }
  it { should allow_mass_assignment_of(:message) }
  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:plan) }

  it "should restrict who can do what" do
    owner = Factory(:user)
    friend = Factory(:user)
    stranger = Factory(:user)
    
    plan = Factory(:plan, :owner => owner)
    plan.users << friend
    plan.save!
    
    plan.owner?(owner).should be_true
    plan.participant?(friend).should be_true
    
    new_comment = Comment.new(:plan => plan)
    owner_comment = Factory(:comment, :plan => plan, :user => owner)
    friend_comment = Factory(:comment, :plan => plan, :user => friend)
    
    describe Ability.new(owner) do
      it { should be_able_to(:create, new_comment) }
      it { should be_able_to(:destroy, owner_comment) }
      it { should be_able_to(:destroy, friend_comment) }
    end
    
    describe Ability.new(friend) do
      it { should be_able_to(:create, new_comment) }
      it { should_not be_able_to(:destroy, owner_comment) }
    end
    
    describe Ability.new(stranger) do
      it { should_not be_able_to(:create, new_comment) }
      it { should_not be_able_to(:destroy, friend_comment) }
    end
  end

end