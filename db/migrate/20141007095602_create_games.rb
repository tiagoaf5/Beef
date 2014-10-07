class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :team1_name
      t.string :team2_name
      t.integer :team1_goals
      t.integer :team2_goals
      t.date :time
      t.references :championship, index: true

      t.timestamps
    end
  end
end
