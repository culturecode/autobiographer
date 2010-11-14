Autobiographer::Application.routes.draw do

  resource :session
  resources :users
  match 'profile', :to => 'users#profile'

  resources :facebook_authentications do
    get :callback, :to => :create, :on => :collection
  end
  resources :foursquare_authentications do
    get :callback, :to => :create, :on => :collection
  end
  resources :twitter_authentications

  resources :events do
    get :sync, :on => :collection
  end
  root :to => 'events#index'
end
