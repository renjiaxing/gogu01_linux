class AddVisibleToMicroposts < ActiveRecord::Migration
  def change
    add_column :microposts, :visible, :boolean,default: true
  end
end
