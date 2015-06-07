class AddSettingColumnsToSettings < ActiveRecord::Migration
  def change
    add_reference :settings, :project, index: true, foreign_key: true
    add_column :settings, :user_with_token, :integer

    add_column :settings, :build_command, :string
    add_column :settings, :test_command, :string
    add_column :settings, :concurrent_jobs, :integer
    add_column :settings, :ignored_files, :text
  end
end
