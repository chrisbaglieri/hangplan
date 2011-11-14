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
end
