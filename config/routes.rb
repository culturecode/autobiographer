Autobiographer::Application.routes.draw do

  resource :session
  resources :users
  match 'profile', :to => 'users#profile'

  resources :facebook_authentications do
    get :callback, :to => :create, :on => :collection
  end

  resources :events do
    get :sync, :on => :collection
  end
  root :to => 'events#index'
  
  resources :chapters
  match 'split_chapter', :to => 'chapters#create'
end
