class CreateAtyresources < ActiveRecord::Migration
  def change
    create_table :atyresources do |t|
      t.string :name
      t.string :aty

      t.timestamps
    end
  end
end
