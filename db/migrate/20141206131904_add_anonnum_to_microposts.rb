class AddAnonnumToMicroposts < ActiveRecord::Migration
  def change
    add_column :microposts, :anonnum, :integer,default: 1
  end
end
