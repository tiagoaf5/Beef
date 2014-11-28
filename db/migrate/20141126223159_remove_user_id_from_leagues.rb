class RemoveUserIdFromLeagues < ActiveRecord::Migration
  def change
    remove_column :leagues, :user_id
  end
end
