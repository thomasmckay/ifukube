RailsApp::Application.routes.draw do

  # Devise for user login
  #devise_for :users
  devise_for :user, :path => '', :path_names => {:sign_in => 'login', :sign_out => 'logout', :sign_up => 'register'}

  resources :tickets do
    collection do
      get :items
    end
  end

  root :to => 'tickets#index'

end
