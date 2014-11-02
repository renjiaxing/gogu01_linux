class CreateGoodrelations < ActiveRecord::Migration
  def change
    create_table :goodrelations do |t|
      t.integer :good_id
      t.integer :begood_id

      t.timestamps
    end
  end
end
