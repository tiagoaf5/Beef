class BetScoreNotification < ActiveRecord::Base
  before_create :act

  def act
    added_at = DateTime.now
    read = false
  end

  def self.start(user)
    return BetScoreNotification.where(user_id: user, read: false).order("added_at desc")
  end

  def self.notify(bet, user)
    notification = BetScoreNotification.new
    notification.user = user
    notification.bet = bet
    notification.save
  end


end
