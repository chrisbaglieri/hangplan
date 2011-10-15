require 'spec_helper'

describe User do
  it { should validate_presence_of(:email) }
  it { should have_and_belong_to_many(:plans) }
  
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
