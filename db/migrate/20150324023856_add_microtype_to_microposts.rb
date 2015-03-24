class AddMicrotypeToMicroposts < ActiveRecord::Migration
  def change
    add_column :microposts, :microtype, :integer,default:0
  end
end
