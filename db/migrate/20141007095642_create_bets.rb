class CreateBets < ActiveRecord::Migration
  def change
    create_table :bets do |t|
      t.integer :team1_goals
      t.integer :team2_goals
      t.integer :score
      t.references :user, index: true
      t.references :game, index: true

      t.timestamps
    end
  end
end
