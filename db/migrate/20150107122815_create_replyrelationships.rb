class CreateReplyrelationships < ActiveRecord::Migration
  def change
    create_table :replyrelationships do |t|
      t.integer :replyuser_id
      t.integer :replymicropost_id
      t.integer :replyunread

      t.timestamps
    end
  end
end
