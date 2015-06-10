class AddWebhookIdToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :webhook_id, :integer
  end
end
