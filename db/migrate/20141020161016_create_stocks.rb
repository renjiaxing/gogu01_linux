class CreateStocks < ActiveRecord::Migration
  def change
    create_table :stocks do |t|
      t.string :code
      t.string :name

      t.timestamps
    end
  end
end
