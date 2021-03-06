## when a user clicks on a notification, this controller marks that notification as read
## and redirects the user to the relevant page
class NotificationsController < ApplicationController
  def show
    if(params[:id]== "all") ## mark all as read
      case params[:type]
        when "score"
          BetScoreNotification.update_all("read = true")
        when "games"
          PendingGamesNotification.update_all("read = true")
        when "invites"
          InvitesNotification.update_all("read = true")
      end
      redirect_to :back ##user stays in the same page
    else
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
          redirect_to(league_games_path(@notification.bet.league)+"#game"+@notification.bet.game.id.to_s)
        when "games"
          redirect_to(league_mybets_path(@notification.league)+"#game"+@notification.game.id.to_s)
        when "invites"
          redirect_to(league_path(@notification.league))
      end
    else
      redirect_to(root_path)
    end
      end
  end



end
