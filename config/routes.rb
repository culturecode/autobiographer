Autobiographer::Application.routes.draw do

  resource :session
  resources :users

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
  
  resources :chapters
  match 'split_chapter', :to => 'chapters#create'
  
  post 'uploads/photos'
  
  match 'pages/:action', :to => 'pages'
end
