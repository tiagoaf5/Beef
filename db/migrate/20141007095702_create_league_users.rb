class CreateLeagueUsers < ActiveRecord::Migration
  def change
    create_table :league_users do |t|
      t.references :user, index: true
      t.references :league, index: true

      t.timestamps
    end
  end
end
