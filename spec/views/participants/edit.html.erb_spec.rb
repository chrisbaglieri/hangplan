require 'spec_helper'

describe "participants/edit.html.erb" do
  before(:each) do
    @participant = assign(:participant, stub_model(Participant,
      :user_id => 1,
      :plan_id => 1,
      :points => 1
    ))
  end

  it "renders the edit participant form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => participants_path(@participant), :method => "post" do
      assert_select "input#participant_user_id", :name => "participant[user_id]"
      assert_select "input#participant_plan_id", :name => "participant[plan_id]"
      assert_select "input#participant_points", :name => "participant[points]"
    end
  end
end
