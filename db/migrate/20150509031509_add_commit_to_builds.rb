class AddCommitToBuilds < ActiveRecord::Migration
  def change
    add_column :builds, :commit, :string
  end
end
