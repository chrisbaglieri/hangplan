Hangplan::Application.routes.draw do  
  
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
  
  resources :plans
  resources :subscriptions, :only => [:new, :create]
end
