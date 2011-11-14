require 'spec_helper'

describe User do
  before do
    @user = Factory(:user)
  end
  
  it { should have_one(:facebook) }
  it { should have_many(:participants) }
  it { have_many(:plans).through(:participants) }
  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email) }
  it { should validate_presence_of(:name) }
  
  describe "plan owner" do
    it "should automatically be added to the plans they own" do
      Factory(:plan, :owner => @user)
      plans = @user.plans
      plans.count.should == 1
    end
  end
end