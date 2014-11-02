class AddIndexToGoodrelaitons < ActiveRecord::Migration
  def change
    add_index :goodrelations,[:good_id,:begood_id],unique: true
  end
end
