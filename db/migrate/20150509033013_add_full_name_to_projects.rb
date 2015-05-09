class AddFullNameToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :full_name, :string
    rename_column :projects, :title, :name
  end
end
