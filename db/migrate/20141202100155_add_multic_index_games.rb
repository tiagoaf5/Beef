class AddMulticIndexGames < ActiveRecord::Migration
  def change
    add_index :games, [:team1_name, :team2_name, :time]
  end
end
