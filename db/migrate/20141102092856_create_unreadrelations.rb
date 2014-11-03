class CreateUnreadrelations < ActiveRecord::Migration
  def change
    create_table :unreadrelations do |t|
      t.integer :unreaduser_id
      t.integer :unreadmicropost_id
      t.integer :unread

      t.timestamps
    end
  end
end
