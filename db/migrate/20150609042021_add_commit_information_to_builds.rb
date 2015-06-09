class AddCommitInformationToBuilds < ActiveRecord::Migration
  def change
    add_column :builds, :author, :string
    add_column :builds, :message, :text
    add_column :builds, :branch, :string
  end
end
