class AddShotnameToStock < ActiveRecord::Migration
  def change
    add_column :stocks, :shortname, :string,default: ""
  end
end
