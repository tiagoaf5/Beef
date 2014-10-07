class CreateChampionships < ActiveRecord::Migration
  def change
    create_table :championships do |t|
      t.integer :year
      t.string :name
      t.string :country

      t.timestamps
    end
  end
end
