class AuthenticationsController < ApplicationController
  def index
    @authentications = current_user.authentications.all
  end

  def create
    omniauth = request.env["omniauth.auth"]

    if authentication = Authentication.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
      flash[:notice] = "Signed in successfully."
      sign_in_and_redirect(:user, authentication.user)
    elsif current_user
      Authentication.create_from_omniauth!(omniauth, :user => current_user)
      flash[:notice] = "Authentication successful."
      redirect_to authentications_url
    else
      auth = Authentication.create_from_omniauth!(omniauth)
      flash[:notice] = "Signed in successfully."
      sign_in_and_redirect(:user, auth.user)
    end
  end

  def destroy
    @authentication = Authentication.find(params[:id])
    @authentication.destroy
    flash[:notice] = "Successfully destroyed authentication."
    redirect_to authentications_url
  end
end
