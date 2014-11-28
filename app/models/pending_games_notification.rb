class PendingGamesNotification < ActiveRecord::Base
  before_create :act

  def act
    added_at = DateTime.now
    read = false
  end

  def self.start(user)
    return PendingGamesNotification.where(user_id: user, read: false).order("added_at desc")
  end

  def self.notify(game,league,user) ##TODO Just input game and then find all...
    notification = PendingGamesNotification.new
    notification.game = game
    notification.league = league
    notification.user = user
    notification.save
  end

end
