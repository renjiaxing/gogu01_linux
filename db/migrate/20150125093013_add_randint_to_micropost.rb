class AddRandintToMicropost < ActiveRecord::Migration
  def change
    add_column :microposts, :randint, :integer,default: 0
  end
end
