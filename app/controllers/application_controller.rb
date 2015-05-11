class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def new_session_path(scope)
    new_user_session_path
  end

  def github_client
    @client ||= Octokit::Client.new(:access_token => current_user.client_token)
  end

  def github_user
    return @github_user if @github_user
    
    @github_user = github_client.user
    @github_user.login

    @github_user
  end
end
