class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :msg
      t.integer :micropost_id

      t.timestamps
    end
  end
end
