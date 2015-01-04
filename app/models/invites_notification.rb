##Model for notifications of new leagues the user was added to

class InvitesNotification < ActiveRecord::Base
  belongs_to :league
  belongs_to :user

  ##doesnt allow repeated notifications (only one notification per league,user pair)
  validates_uniqueness_of :league, scope: [:user]

  def self.start(user) ## returns unread notifications
    return InvitesNotification.where(user_id: user, read: false).order("added_at desc")
  end

  def self.notify(league,user)## adds a new notification
    InvitesNotification.create(league: league, user: user, added_at: DateTime.now, read: false)
  end

end
