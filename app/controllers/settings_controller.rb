class SettingsController < ApplicationController
  def index
    @project = Project.find(params['project_id'])
    @project_watchers = @project.users.map { |u| [ u.github_login, u.email ] }
    @project_ignored_files_text = JSON.parse(@project.setting.ignored_files).join("\n")
  end

  def update
    @project = Project.find(params[:project_id])
    params[:setting][:ignored_files] = params[:setting][:ignored_files].lines.map(&:strip).to_json
    @project.setting.update_attributes(params[:setting].permit(User.find_by_email(:user_with_token), :concurrent_jobs, :build_command, :test_command, :ignored_files))
    flash[:notice] = 'Settings updated'
    redirect_to action: 'index'
  end
end
