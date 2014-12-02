class AddPendingUserToLeague < ActiveRecord::Migration
  def change
    create_table :pending_users do |t|
      t.datetime :added_at
      t.boolean :read
      t.text :email
      t.references :leagues
    end
  end
end
