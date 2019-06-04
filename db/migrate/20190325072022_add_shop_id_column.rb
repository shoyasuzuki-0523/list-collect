class AddShopIdColumn < ActiveRecord::Migration[5.2]
  def change
    add_column :links, :shop_id, :integer
  end
end
