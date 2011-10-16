require 'spec_helper'

describe "participants/show.html.erb" do
  before(:each) do
    @participant = assign(:participant, stub_model(Participant,
      :user_id => 1,
      :plan_id => 1,
      :points => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
  end
end
