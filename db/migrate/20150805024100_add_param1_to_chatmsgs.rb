class AddParam1ToChatmsgs < ActiveRecord::Migration
  def change
    add_column :chatmsgs, :param1, :string
  end
end
