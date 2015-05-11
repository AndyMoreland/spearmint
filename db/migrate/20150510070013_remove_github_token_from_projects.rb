class RemoveGithubTokenFromProjects < ActiveRecord::Migration
  def change
    remove_column :projects, :github_token, :string
  end
end
