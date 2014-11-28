class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  #before_action :authenticate_user!
  before_action :get_leagues

  before_action :configure_permitted_parameters, if: :devise_controller?

  before_action :list_pending_notifications

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :name
    devise_parameter_sanitizer.for(:sign_up) << :image
  end


  def index

  end


  private

  def get_leagues
    if user_signed_in?
      @user_leagues = current_user.leagues
    end
  end

  def list_pending_notifications
    if user_signed_in?
      @score_notifications = BetScoreNotification.start(current_user)
      @invites_notifications = InvitesNotification.start(current_user)
      @games_notifications = PendingGamesNotification.start(current_user)
    end
  end

end
