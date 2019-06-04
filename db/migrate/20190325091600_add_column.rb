class AddColumn < ActiveRecord::Migration[5.2]
  def change
    add_column :shops, :phone_number, :text
  end
end
