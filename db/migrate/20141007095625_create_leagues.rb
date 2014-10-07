class CreateLeagues < ActiveRecord::Migration
  def change
    create_table :leagues do |t|
      t.string :name
      t.integer :score_correct
      t.integer :score_difference
      t.integer :score_prediction
      t.references :user, index: true

      t.timestamps
    end
  end
end
