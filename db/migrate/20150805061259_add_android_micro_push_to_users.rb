class AddAndroidMicroPushToUsers < ActiveRecord::Migration
  def change
    add_column :users, :android_micro_push, :boolean,default:1
    add_column :users, :android_reply_push, :boolean,default:1
    add_column :users, :android_chat_push, :boolean,default:1
  end
end
