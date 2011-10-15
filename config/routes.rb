Hangplan::Application.routes.draw do  
  
  devise_for :users, :path_names => { :sign_up => "register", :sign_in => "login", :sign_out => "logout"  }
  devise_scope :user do
    get "/login" => "devise/sessions#new"
    get "/logout" => "devise/sessions#destroy"
  end

  root :to => "pages#home"
  match "team" => 'pages#team', :via => :get
  match "contact" => 'pages#contact', :via => :get
  
  resources :plans, :except => [:index]
  
end
