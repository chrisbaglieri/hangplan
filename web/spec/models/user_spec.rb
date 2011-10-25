require 'spec_helper'

describe User do
  it { should have_many(:participants) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:name) }
  it { should have_many(:plans) }
  
  describe "owners" do
    before do
      @owner = Factory(:user)
    end

    it "should automatically be added to the plans they own" do
      Factory(:plan, :owner => @owner)
      plans = @owner.plans
      plans.count.should == 1
    end
  end
end
