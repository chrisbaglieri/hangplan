require 'spec_helper'

describe Facebook do
  before do
    @facebook = Factory(:facebook)
  end
  
  it { should allow_value("facebook").for(:source) }
  
  it "should default to a source of facebook" do
    facebook = Facebook.new
    facebook.source.should == "facebook"
  end
  
  it "should load the connection details" do
    Facebook.config[:client_id].should == 294574140563371
    Facebook.config[:client_secret].should == "92b860b087093b91f6629afbd047d1e1"
    Facebook.config[:scope].should == "user_events,user_location,email,user_checkins,create_event,rsvp_event,offline_access"
    Facebook.config[:canvas_url].should == "http://apps.facebook.com/hangplan"
  end
end
