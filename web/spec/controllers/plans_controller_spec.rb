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
  
  describe 'POST create' do
    it 'creates a tentative plan (html)' do
      post :create, :plan => { :name => 'Hanging out', :location => 'Tavern', :tentative => 1 }
      assigns(:plan).should be_persisted
      assigns(:plan).name.should eq('Hanging out')
      assigns(:plan).location.should eq('Tavern')
      assigns(:plan).tentative.should eq(true) 
      response.should redirect_to(assigns(:plan))
    end
    
    it 'handles validation errors (html)' do
      post :create
      assigns(:plan).should be_a_new(Plan)
      assigns(:plan).errors.should_not be_empty
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
    
    it 'rejects unauthorized edits (html)' do
      plan = Factory(:plan)  # :owner => Factory(:user)
      get :edit, :id => plan.id
      response.code.should eq('403')
    end
    
    it 'rejects unauthorized edits (json)' do
      plan = Factory(:plan)
      get :edit, :id => plan.id, :format => :json
      response.code.should eq('403')
      response.body.should include('Access denied')
    end
  end
  
  describe 'PUT update' do
    it 'rejects unauthorized updates (html)' do
      plan = Factory(:plan)
      put :update, :id => plan.id
      response.code.should eq('403')
    end
    
    it 'updates a plan (html)' do
      plan = Factory(:plan, :owner => @user)
      put :update, :id => plan.id, :plan => { :name => 'Hanging out', :location => 'Bar' }
      assigns(:plan).should_not be_nil
      assigns(:plan).should be_persisted
      assigns(:plan).name.should eq('Hanging out')
      assigns(:plan).location.should eq('Bar')
      response.should redirect_to(assigns(:plan))
    end
  end
  
  describe 'DELETE destroy' do
    it 'rejects unauthorized deletes (html)' do
      plan = Factory(:plan)
      delete :destroy, :id => plan.id
      response.code.should eq('403')
    end
    
    it 'deletes a plan I own (html)' do
      plan = Factory(:plan, :owner => @user)
      delete :destroy, :id => plan.id
      flash[:notice].should_not be_blank
      response.should redirect_to(root_path)
      Plan.find_by_id(plan.id).should be_nil
    end
  end
end

