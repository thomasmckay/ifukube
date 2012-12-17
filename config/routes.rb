RailsApp::Application.routes.draw do

  # Devise for user login
  #devise_for :users
  devise_for :user, :path => '', :path_names => {:sign_in => 'login', :sign_out => 'logout', :sign_up => 'register'}

  match 'tickets' => 'application#tickets'

  root :to => 'application#index'

end
