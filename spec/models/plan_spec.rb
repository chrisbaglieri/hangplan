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
  
  it "should be able to fetch plans before a date" do
    Factory(:plan, :owner => @user, :start_date_s => 2.weeks.ago.strftime('%m/%d/%Y'))
    Factory(:plan, :owner => @user, :start_date_s => 2.weeks.from_now.strftime('%m/%d/%Y'))
    today = DateTime.now
    Plan.on_or_before(today).each do |plan|
      plan.start_at.should <= today
    end
  end
  
  it "should be able to fetch plans after a date" do
    Factory(:plan, :owner => @user, :start_date_s => 2.weeks.ago.strftime('%m/%d/%Y'))
    Factory(:plan, :owner => @user, :start_date_s => 2.weeks.from_now.strftime('%m/%d/%Y'))
    today = DateTime.now
    Plan.on_or_after(today).each do |plan|
      plan.start_at.should >= today
    end
  end
  
  it "should parse a valid start date and time" do
    p = Factory(:plan, :start_date_s => '11/05/2011', :start_time_s => '13:30')
    p.should_not be_nil
    p.should be_valid
    p.should be_persisted
    p.start_at.should eq(Time.zone.parse('2011-11-05 13:30:00'))
    p.end_at.should be_nil
  end
  
  it "should work in the end times" do
    p = Factory(:plan, :start_date_s => '11/05/2011', :start_time_s => '13:30', :end_time_s => '16:30')
    p.should_not be_nil
    p.should be_valid
    p.should be_persisted
    p.start_at.should eq(Time.zone.parse('2011-11-05 13:30:00'))
    p.end_at.should eq(Time.zone.parse('2011-11-05 16:30:00'))
  end
  
  it "should handle daylight savings" do
    Time.use_zone 'America/New_York' do
      p1 = Factory(:plan, :start_date_s => '11/05/2011', :start_time_s => '13:30', :end_time_s => '16:30')
      p1.start_at.should eq(Time.zone.parse('2011-11-05, 13:30:00')) # spring ahead
      p1.start_at.utc_offset.should eq(-4*60*60)
      p1.end_at.should eq(Time.zone.parse('2011-11-05 16:30:00'))
      p1.end_at.utc_offset.should eq(p1.start_at.utc_offset)
      p2 = Factory(:plan, :start_date_s => '11/06/2011', :start_time_s => '13:30', :end_time_s => '16:30')
      p2.start_at.should eq(Time.zone.parse('2011-11-06, 13:30:00')) # fall behind
      p2.start_at.utc_offset.should eq(-5*60*60)
      p2.end_at.should eq(Time.zone.parse('2011-11-06 16:30:00'))
      p2.end_at.utc_offset.should eq(p2.start_at.utc_offset)
    end
  end
  
  it "should handle Pacific Standard/Daylight Time" do
    Time.use_zone 'America/Los_Angeles' do
      p1 = Factory(:plan, :start_date_s => '11/05/2011', :start_time_s => '13:30', :end_time_s => '16:30')
      p1.start_at.should eq(Time.zone.parse('2011-11-05, 13:30:00')) # spring ahead
      p1.start_at.utc_offset.should eq(-7*60*60)
      p1.end_at.should eq(Time.zone.parse('2011-11-05 16:30:00'))
      p1.end_at.utc_offset.should eq(p1.start_at.utc_offset)
      p2 = Factory(:plan, :start_date_s => '11/06/2011', :start_time_s => '13:30', :end_time_s => '16:30')
      p2.start_at.should eq(Time.zone.parse('2011-11-06, 13:30:00')) # fall behind
      p2.start_at.utc_offset.should eq(-8*60*60)
      p2.end_at.should eq(Time.zone.parse('2011-11-06 16:30:00'))
      p2.end_at.utc_offset.should eq(p2.start_at.utc_offset)
    end
  end
  
  it "should handle Phoenix Time (no DST)" do
    Time.use_zone 'America/Phoenix' do
      p1 = Factory(:plan, :start_date_s => '11/05/2011', :start_time_s => '13:30', :end_time_s => '16:30')
      p1.start_at.should eq(Time.zone.parse('2011-11-05, 13:30:00')) 
      p1.start_at.utc_offset.should eq(-7*60*60)
      p1.end_at.should eq(Time.zone.parse('2011-11-05 16:30:00'))
      p1.end_at.utc_offset.should eq(p1.start_at.utc_offset)
      p2 = Factory(:plan, :start_date_s => '11/06/2011', :start_time_s => '13:30', :end_time_s => '16:30')
      p2.start_at.should eq(Time.zone.parse('2011-11-06, 13:30:00')) # None of that here
      p2.start_at.utc_offset.should eq(-7*60*60)
      p2.end_at.should eq(Time.zone.parse('2011-11-06 16:30:00'))
      p2.end_at.utc_offset.should eq(p2.start_at.utc_offset)
    end
  end
  
end
