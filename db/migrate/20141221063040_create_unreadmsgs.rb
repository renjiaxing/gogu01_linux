class CreateUnreadmsgs < ActiveRecord::Migration
  def change
    create_table :unreadmsgs do |t|
      t.integer :msgfrom_id
      t.integer :msgto_id
      t.integer :msgunread,default:0

      t.timestamps
    end
  end
end
