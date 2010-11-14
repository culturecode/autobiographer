Autobiographer::Application.routes.draw do

  resource :session
  resources :users
  match 'profile', :to => 'users#profile'

  resources :facebook_authentications do
    get :callback, :to => :create, :on => :collection
  end

  resources :events, :as => 'memoirs'  
  root :to => 'events#index'
end
