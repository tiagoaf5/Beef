##Model for notifications about the result of a bet

class BetScoreNotification < ActiveRecord::Base
  belongs_to :user
  belongs_to :bet

  ##doesnt allow repeated notifications
  validates_uniqueness_of :bet, scope: [:user]

  def self.start(user) ## returns unread notifications
    return BetScoreNotification.where(user_id: user, read: false).order("added_at desc")
  end

  def self.notify(bet, user) ## adds a new notification
    BetScoreNotification.create(user: user, bet: bet, added_at: DateTime.now, read: false)
  end


end
