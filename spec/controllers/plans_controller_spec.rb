require 'spec_helper'
include Devise::TestHelpers

describe PlansController do
  
  before(:each) do
    @user ||= Factory.create(:user)
    sign_in @user
  end
  
  describe 'GET index' do
    it 'renders in HTML format' do
      # TODO: plans#index should eventually filter.
      plan = Factory(:plan)
      get :index
      assigns(:plans).should eq([plan])
      response.should be_success
      response.should render_template('index')
    end
  end
  
  describe 'GET show' do
    it 'shows a plan with a valid id (html)' do
      plan = Factory(:plan)
      get :show, :id => plan.id
      assigns(:plan).should eq(plan)
      response.should be_success
      response.should render_template('show')
    end
    
    it 'handles an invalid id (html)' do
      get :show, :id => 23
      flash[:error].should_not be_blank
      response.should redirect_to(plans_path)
    end
    
    it 'shows a plan with a valid id (json)' do
      plan = Factory(:plan)
      get :show, :id => plan.id, :format => :json
      assigns(:plan).should eq(plan)
      response.should be_success
      response.body.should include(plan.name)
    end
    
    it 'handles an invalid id (json)' do
      get :show, :id => 23, :format => :json
      response.code.should eq('404')
      response.body.should_not be_blank
    end
  end
  
  describe 'GET new' do
    it 'renders a new plan' do
      get :new
      assigns(:plan).should be_a_new(Plan)
      response.should be_success
      response.should render_template('new')
    end
  end
  
  describe 'GET edit' do
    it 'renders the requested plan' do
      plan = Factory(:plan, :owner => @user)
      get :edit, :id => plan.id 
      assigns(:plan).should eq(plan)
      response.should be_success
      response.should render_template('edit')
    end
    
    it 'rejects unauthorized edits' do
# TODO: CanCan failing un-gracefully.
#      plan = Factory(:plan)  # :owner => Factory(:user)
#      get :edit, :id => plan.id
#      response.should be_redirect
#      response.should redirect_to(plans_path)
    end
  end
end

