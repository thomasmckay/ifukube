RailsApp::Application.routes.draw do

  # Devise for user login
  devise_for :user, :path => '', :path_names => {:sign_in => 'login', :sign_out => 'logout', :sign_up => 'register'}

  # Tickets
  resources :tickets do
    collection do
      get :auto_complete_search
      get :items
    end
    member do
      get :edit
      get :new
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
