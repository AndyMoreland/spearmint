class AddDefaultSettingsToSettings < ActiveRecord::Migration
  def change
    change_column :settings, :user_with_token, :integer, null: false
    change_column :settings, :concurrent_jobs, :integer, null: false, default: 2
  end
end
