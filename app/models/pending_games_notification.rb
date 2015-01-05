##Model for notifications of games starting in the next days

class PendingGamesNotification < ActiveRecord::Base
  belongs_to :user
  belongs_to :league
  belongs_to :game

  ##doesnt allow more than one notification of a pending game for a user,league pair
  validates_uniqueness_of :game, scope: [:user, :league]

  def self.start(user) ## returns unread notifications and marks the games already started as read
    PendingGamesNotification.joins(:game).where("user_id = ? and read = false and time < ?",user,DateTime.now).update_all(read: true)
    return PendingGamesNotification.joins(:game).where(user_id: user, read: false).order("time asc")
  end

  def self.notify(game)  ## adds a new notification if there's no prior bet
    game.championship.leagues.each do |league|
      league.users.each do |user|
        if league.bets.where(user: user, game: game).blank?
          PendingGamesNotification.create(user: user, game: game, league: league, added_at: DateTime.now, read: false)
        end
      end
    end
  end

end
