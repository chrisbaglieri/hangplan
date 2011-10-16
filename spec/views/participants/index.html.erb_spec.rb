require 'spec_helper'

describe "participants/index.html.erb" do
  before(:each) do
    assign(:participants, [
      stub_model(Participant,
        :user_id => 1,
        :plan_id => 1,
        :points => 1
      ),
      stub_model(Participant,
        :user_id => 1,
        :plan_id => 1,
        :points => 1
      )
    ])
  end

  it "renders a list of participants" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
