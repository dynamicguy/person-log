PersonLog::Application.routes.draw do

  resources :images


  resources :galleries


  mount Tolk::Engine => '/tolk', :as => 'tolk'
  resources :permissions
  resources :visits
  get "moderators/versions"
  get "moderators/dashboard"
  get "/pages/:id" => 'pages#show', :as => :page
  get "import" => "import#index"
  get "import/twitter"
  get "import/facebook"
  get "import/linkedin"
  get "import/github"
  get "import/google"
  get "import/linkedin_profile"
  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'
  get "/persons/search" => "users#search"
  get "/persons/map" => "users#map"
  get "/persons/tags" => "users#tags"
  get "/friends" => "users#friends"
  get "/persons/typeahead" => "users#typeahead"
  get "/persons/list" => "users#list"
  get "/persons/manage" => "users#manage"
  match "/persons/update_address/:id/:address" => "users#update_address"

  get 'tags/:tag', :to => 'users#index', :as => :tag
  resources :queries

  devise_for :users, :path => "persons", :controllers => {:registrations => 'registrations',
                                                          :invitations => 'users/invitations',
                                                          :confirmations => "confirmations",
                                                          :omniauth_callbacks => "users/omniauth_callbacks"}
  #resources :users, :path => 'persons', only: [:show, :index, :edit, :update]
  match 'persons/bulk_invite/:quantity' => 'users#bulk_invite', :via => :get, :as => :bulk_invite
  match 'persons/bulk_action' => 'users#bulk_action', :via => :get, :as => :bulk_user_action
  resources :users, :path => 'persons' do
    get 'invite', :on => :member
  end

  authenticated :user do
    root :to => 'home#index'
  end

  devise_scope :user do
    root :to => "registrations#new"
    match '/user/confirmation' => 'confirmations#update', :via => :put, :as => :update_user_confirmation
  end

  resources :authentications
  resources :positions
  resources :educations
  resources :companies
  resources :urls
  resources :newsletters do
    member { post :deliver }
  end
  match "versions/:id/revert" => "versions#revert", :as => "revert_version"
  get "versions" => "versions#index"
  get "versions/:id" => "versions#show", :as => :version
end
