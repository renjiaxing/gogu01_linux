class CreateMystocks < ActiveRecord::Migration
  def change
    create_table :mystocks do |t|
      t.integer :user_id
      t.integer :stock_id

      t.timestamps
    end
  end
end
