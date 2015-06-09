class SettingsController < ApplicationController
  def index
    @project = Project.find(params['project_id'])
    @project_watchers = @project.users.map { |u| [ u.email, u.email ] }
  end

  def update
    @project = Project.find(params[:project_id])
    @project.setting.update_attributes(params[:setting].permit(User.find_by_email(:user_with_token), :concurrent_jobs, :build_command, :test_command, :ignored_files))
    redirect_to action: 'index'
  end
end
