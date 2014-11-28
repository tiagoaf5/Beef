class NotificationsController < ApplicationController

  def show
    @notification = nil
    case params[:type]
      when "score"
        @notification = BetScoreNotification.find(params[:id])
      when "games"
        @notification = PendingGamesNotification.find(params[:id])
      when "invites"
        @notification = InvitesNotification.find(params[:id])
    end
    if @notification != nil
      @notification.read = true
      @notification.save
      case params[:type]
        when "score"
          redirect_to(league_path(@notification.bet.league)) ##TODO add path to specific game
        when "games"
          redirect_to(league_path(@notification.league)) ##TODO add path to specific game
        when "invites"
          redirect_to(league_path(@notification.league))
      end
    else
      redirect_to(root_path)
    end
  end



end
