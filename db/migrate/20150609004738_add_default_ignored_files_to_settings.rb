class AddDefaultIgnoredFilesToSettings < ActiveRecord::Migration
  def change
    change_column :settings, :ignored_files, :text, default: "[\"node_modules\",\"jquery*.js\"]"
  end
end
