class RemoveColumn < ActiveRecord::Migration[5.2]
  def change
    remove_column :shops, :url
  end
end
