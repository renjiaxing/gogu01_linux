class CreateAnons < ActiveRecord::Migration
  def change
    create_table :anons do |t|
      t.integer :anonuser_id
      t.integer :anonmicropost_id
      t.integer :anonnum

      t.timestamps
    end
  end
end
