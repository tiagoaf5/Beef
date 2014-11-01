class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  #before_action :authenticate_user!
  before_action :get_leagues

  def index

  end

  private

  def get_leagues
    if user_signed_in?
      @user_leagues = current_user.leagues
    end
  end

end
