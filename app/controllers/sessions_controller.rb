class SessionsController < ApplicationController
  before_action :require_not_logged_in!, only: [:new, :create]

  def new
    # @user = User.new
    redirect_to cats_url if current_user
  end

  def create
    user = User.find_by_credentials(
              params[:user][:user_name], params[:user][:password])
    if user.nil?
      render :new
    else
      login_user!(user)
      redirect_to cats_url
    end
  end

  def destroy
    current_user.try(:reset_session_token!)
    session[:session_token] = nil
    redirect_to new_session_url
  end
end
