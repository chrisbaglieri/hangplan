Hangplan::Application.routes.draw do  
  
  devise_for :users, 
    :path_names => { :sign_up => "register", :sign_in => "login", :sign_out => "logout"  }
    
  devise_scope :user do
    get "/login" => "devise/sessions#new"
    get "/logout" => "devise/sessions#destroy"
  end
  
  root :to => "pages#home"
  
  match "about" => 'pages#about', :via => :get
  match "contact" => 'pages#contact', :via => :get
  match "faq" => 'pages#faq', :via => :get
  match 'profile' => 'users#show', :via => :get
  match "notifications" => 'notifications#index', :via => :get
  
  resources :users, :only => [:show]
  resources :plans do
    resources :participants, :only => [:create]
    resources :comments, :only => [:create] 
  end
  resources :participants, :only => [:update, :destroy]
  resources :comments, :only => [:destroy]
  resources :friends, :controller => 'friendships', :only => [:index, :create] do
    collection do
      put 'approve'
      delete 'remove'
    end
  end
  
end
