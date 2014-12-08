class CreatePmsgs < ActiveRecord::Migration
  def change
    create_table :pmsgs do |t|
      t.integer :fromuser_id
      t.integer :touser_id
      t.text :msg

      t.timestamps
    end
  end
end
