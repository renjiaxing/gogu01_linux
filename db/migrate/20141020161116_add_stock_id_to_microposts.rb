class AddStockIdToMicroposts < ActiveRecord::Migration
  def change
    add_column :microposts, :stock_id, :integer
  end
end
