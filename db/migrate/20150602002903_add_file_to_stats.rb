class AddFileToStats < ActiveRecord::Migration
  def change
    add_column :stats, :file, :string
  end
end
