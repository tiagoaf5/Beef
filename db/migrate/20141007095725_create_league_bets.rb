class CreateLeagueBets < ActiveRecord::Migration
  def change
    create_table :league_bets do |t|
      t.references :league, index: true
      t.references :bet, index: true

      t.timestamps
    end
  end
end
