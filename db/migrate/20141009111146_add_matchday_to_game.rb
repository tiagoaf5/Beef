class AddMatchdayToGame < ActiveRecord::Migration
  def change
    add_column :games, :matchday, :integer
  end
end
