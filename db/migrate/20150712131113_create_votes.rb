class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.integer :user_id
      t.integer :answer_id

      t.timestamps
    end
    add_index :votes,[:answer_id,:user_id],unique: true
  end
end
