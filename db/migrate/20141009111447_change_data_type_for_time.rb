class ChangeDataTypeForTime < ActiveRecord::Migration
  def change
    change_column :games, :time, :datetime
  end
end
