class AddAnontonumToPmsgs < ActiveRecord::Migration
  def change
    add_column :pmsgs, :anontonum, :integer
  end
end
