class AddMobileTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :mobile_toke, :string
  end
end
