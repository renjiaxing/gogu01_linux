class AddVotenumToPolls < ActiveRecord::Migration
  def change
    add_column :polls, :votenum, :integer
  end
end
