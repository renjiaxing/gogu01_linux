class AddRandintToUser < ActiveRecord::Migration
  def change
    add_column :users, :randint, :integer,default:0
  end
end
