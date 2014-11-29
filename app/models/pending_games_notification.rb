class PendingGamesNotification < ActiveRecord::Base
  belongs_to :user
  belongs_to :league
  belongs_to :game

  def self.start(user)
    PendingGamesNotification.joins(:game).where("user_id = ? and read = false and time < ?",user,DateTime.now).update_all(read: true)
    return PendingGamesNotification.where(user_id: user, read: false).order("added_at desc")
  end

  def self.notify(game,league,user) ##TODO Just input game and then find all...
    PendingGamesNotification.create(user: user, game: game, league: league, added_at: DateTime.now, read: false)
  end

end
