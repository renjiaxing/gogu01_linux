class AddAtyresourceIdToChatmsgs < ActiveRecord::Migration
  def change
    add_column :chatmsgs, :atyresource_id, :integer
  end
end
