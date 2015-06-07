class AddPullIdToBuilds < ActiveRecord::Migration
  def change
    add_column :builds, :pull_id, :integer
  end
end
