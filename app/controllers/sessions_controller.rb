class SessionsController < Devise::SessionsController

  def create
    params[:user] = {}
    params[:user][:email] = params[:username]
    params[:user][:password] = params[:password]

    self.resource = warden.authenticate!(auth_options)
    set_flash_message(:notice, :signed_in) if is_navigational_format?
    sign_in(resource_name, resource)

    respond_to do |format|
      format.html { redirect_to tickets_path }
      format.js { render :js => "window.location.href = '#{root_path}'" }
    end
  end

end
