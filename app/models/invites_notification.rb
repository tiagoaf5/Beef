class InvitesNotification < ActiveRecord::Base
  belongs_to :league
  belongs_to :user

  validates_uniqueness_of :league, scope: [:user]

  def self.start(user)
    return InvitesNotification.where(user_id: user, read: false).order("added_at desc")
  end

  def self.notify(league,user)
    InvitesNotification.create(league: league, user: user, added_at: DateTime.now, read: false)
  end

end
