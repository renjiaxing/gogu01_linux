class AddAppleMicroPushToUsers < ActiveRecord::Migration
  def change
    add_column :users, :apple_micro_push, :boolean,default:1
    add_column :users, :apple_reply_push, :boolean,default:1
    add_column :users, :apple_chat_push, :boolean,default:1
  end
end
