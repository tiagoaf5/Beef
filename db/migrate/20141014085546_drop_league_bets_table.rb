class DropLeagueBetsTable < ActiveRecord::Migration
  def change
    drop_table :league_bets
  end
end
