class CreateUserconfigs < ActiveRecord::Migration
  def change
    create_table :userconfigs do |t|
      t.string :name
      t.string :value

      t.timestamps
    end
  end
end
