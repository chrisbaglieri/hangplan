Hangplan::Application.routes.draw do  
  
  resources :participants

  devise_for :users, 
    :path_names => { :sign_up => "register", :sign_in => "login", :sign_out => "logout"  },
    :controllers => { :omniauth_callbacks => 'users/omniauth_callbacks' }
    
  devise_scope :user do
    get "/login" => "devise/sessions#new"
    get "/logout" => "devise/sessions#destroy"
    get '/users/auth/:provider' => 'users/omniauth_callbacks#passthru'
  end

  root :to => "pages#home"
  match "about" => 'pages#about', :via => :get
  match "contact" => 'pages#contact', :via => :get
  match 'profile' => 'users#show', :via => :get
  
  resources :plans do
    resources :participants, :only => [:create]
  end
  
  resources :participants, :only => [:update, :destroy]
  resources :subscriptions, :only => [:new, :create]
  resources :users, :only => [:show]
  
end
