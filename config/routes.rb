Autobiographer::Application.routes.draw do  
  resource :session
  resources :facebook_authentications do
    get :callback, :to => :create, :on => :collection
  end
  root :to => 'users#profile'
  match 'profile', :to => 'users#profile'
end
