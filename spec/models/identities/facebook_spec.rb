require 'spec_helper'

describe Facebook do
  it { should allow_value("facebook").for(:source) }
  
  it "should default to a source of facebook" do
    facebook = Facebook.new
    facebook.source.should == "facebook"
  end
end
