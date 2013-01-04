RailsApp::Application.routes.draw do

  # Devise for user login
  devise_for :user, 
    :path_names => {:sign_in => 'login', 
                    :sign_out => 'logout', 
                    :sign_up => 'register'}, 
    :controllers => { :sessions => 'sessions' } do

      # Sessions
      post '/login'         => 'sessions#create',       :as => :user_session
      get  '/login'         => 'sessions#new',          :as => :new_user_session
      get  '/logout'        => 'sessions#destroy',      :as => :destroy_user_session
    end


  # Tickets
  resources :tickets do
    collection do
      get :auto_complete_search
      get :items
    end
    member do
      get :edit
      get :new
      post :create
      post :update
    end
  end

  resources :ticket_bundles do
    member do
      post :create
      post :update
    end
  end

  # Search
  resources :search, :only => {} do
    get 'show', :on => :collection

    get 'history', :on => :collection
    delete 'history' => 'search#destroy_history', :on => :collection

    get 'favorite', :on => :collection
    post 'favorite' => 'search#create_favorite', :on => :collection
    delete 'favorite/:id' => 'search#destroy_favorite', :on => :collection, :as => 'destroy_favorite'
  end


  root :to => 'tickets#index'

end
