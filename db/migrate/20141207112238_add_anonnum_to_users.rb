class AddAnonnumToUsers < ActiveRecord::Migration
  def change
    add_column :users, :anonnum, :integer,default: 1
  end
end
