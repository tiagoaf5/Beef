class CreateLeagueChampionships < ActiveRecord::Migration
  def change
    create_table :league_championships do |t|
      t.references :league, index: true
      t.references :championship, index: true

      t.timestamps
    end
  end
end
