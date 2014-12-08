class AddAnonnumToPmsgs < ActiveRecord::Migration
  def change
    add_column :pmsgs, :anonnum, :integer
  end
end
