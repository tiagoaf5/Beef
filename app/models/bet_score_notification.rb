class BetScoreNotification < ActiveRecord::Base
  belongs_to :user
  belongs_to :bet

  validates_uniqueness_of :bet, scope: [:user]

  def self.start(user)
    return BetScoreNotification.where(user_id: user, read: false).order("added_at desc")
  end

  def self.notify(bet, user)
    BetScoreNotification.create(user: user, bet: bet, added_at: DateTime.now, read: false)
  end


end
