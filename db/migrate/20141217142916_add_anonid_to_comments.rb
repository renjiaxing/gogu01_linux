class AddAnonidToComments < ActiveRecord::Migration
  def change
    add_column :comments, :anonid, :string,default: 0
  end
end
