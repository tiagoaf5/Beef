class Addscore < ActiveRecord::Migration
  def change
    add_column :league_users, :user_score, :integer
  end
end
