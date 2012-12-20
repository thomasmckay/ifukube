class SessionsController < Devise::SessionsController

  def create
    params[:user] = {}
    params[:user][:email] = params[:username]
    params[:user][:password] = params[:password]

    self.resource = warden.authenticate!(auth_options)
    set_flash_message(:notice, :signed_in) if is_navigational_format?
    sign_in(resource_name, resource)
    redirect_to root_path
  end

end
