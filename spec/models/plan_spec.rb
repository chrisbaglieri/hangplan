require 'spec_helper'

describe Plan do
  before do
    @user = Factory(:user)
  end
  
  it { should belong_to(:owner) }
  it { should have_many(:participants) }
  it { should allow_mass_assignment_of(:name) }
  it { should allow_mass_assignment_of(:location) }
  it { should allow_mass_assignment_of(:time) }
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
end
