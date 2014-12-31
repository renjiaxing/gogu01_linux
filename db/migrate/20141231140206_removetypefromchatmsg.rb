class Removetypefromchatmsg < ActiveRecord::Migration
  def change
    remove_column :chatmsgs,:type
    add_column :chatmsgs,:msgtype,:string
  end
end
