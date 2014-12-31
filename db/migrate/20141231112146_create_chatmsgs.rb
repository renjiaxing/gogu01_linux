class CreateChatmsgs < ActiveRecord::Migration
  def change
    create_table :chatmsgs do |t|
      t.integer :type
      t.string :title
      t.string :content
      t.string :topshow

      t.timestamps
    end
  end
end
