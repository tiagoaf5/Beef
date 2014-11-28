class CreateInvitesNotifications < ActiveRecord::Migration
  def change
    create_table :invites_notifications do |t|
      t.datetime :added_at
      t.boolean :read
      t.references :user, index: true
      t.references :league, index: true
    end
  end
end
