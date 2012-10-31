PersonLog::Application.routes.draw do
  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'

  #match 'auth/:provider/callback', to: 'sessions#create'
  #match 'auth/failure', to: redirect('/')

  get "/users/search"           => "users#search"
  get "/users/typeahead"           => "users#typeahead"
  get 'tags/:tag', to: 'users#index', as: :tag


  devise_for :users, :path => "persons", controllers: { :registrations => 'registrations',
      :omniauth_callbacks => "users/omniauth_callbacks" }
  devise_scope :user do
    get '/sign-in'  => 'sessions#new',     as: :sign_in
    get '/sign-out' => 'sessions#destroy', as: :sign_out
  end
  resources :users, :path => 'persons', only: [:show, :index, :edit, :update]
  # Redirects after switching users to persons
  match "/users/sign_up"        => redirect("/persons/sign_up")
  match "/users/sign_in"        => redirect("/persons/sign_in")
  match "/users/password/new"   => redirect("/persons/password/new")
  match "/users/edit"           => redirect("/persons/edit")
  match "/users"                => redirect("/persons")
  match "/users/:id/edit"       => redirect("/persons/:id/edit")
  match "/users/:id"            => redirect("/persons/:id")

  authenticated :user do
    root :to => 'home#index'
  end
  root :to => "home#index"
  resources :authentications
end
