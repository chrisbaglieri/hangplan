require 'spec_helper'

describe Plan do
  before do
    @user = Factory(:user)
  end
  
  it { should belong_to(:owner) }
  it { should have_many(:participants) }
  it { should allow_mass_assignment_of(:name) }
  it { should allow_mass_assignment_of(:location) }
  it { should allow_mass_assignment_of(:date) }
  it { should allow_mass_assignment_of(:latitude) }
  it { should allow_mass_assignment_of(:longitude) }
  it { should allow_mass_assignment_of(:sponsored) }
  it { should allow_mass_assignment_of(:tentative) }
  it { should allow_mass_assignment_of(:link) }
  it { should have_many(:users) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:owner) }
  
  describe "plan owner" do
    it "should be able to determine if a plan is theirs" do
      plan = Factory(:plan, :owner => @user)
      plan.owner?(@user).should == true
    end
  end
  
  it "should be able to fetch confirmed plans" do
    Factory(:plan, :owner => @user)
    Plan.confirmed.each do |plan|
      plan.tentative.should == false
    end
  end
  
  it "should be able to fetch unconfirmed plans" do
    Factory(:plan, :owner => @user, :tentative => true)
    Plan.unconfirmed.each do |plan|
      plan.tentative.should == true
    end
  end
  
  it "should be able to fetch upcoming plans" do
    Factory(:plan, :owner => @user, :date => 2.weeks.ago)
    Factory(:plan, :owner => @user, :date => 2.weeks.from_now)
    Plan.upcoming(1.week.ago).each do |plan|
      plan.date.should >= 1.week.ago.to_datetime
    end
  end
end
