class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :github_username

  def new_session_path(scope)
    new_user_session_path
  end

  def github_client
    @client ||= current_user.github_client
    @client.login
    
    @client
  end

  def github_user
    return @github_user if @github_user
    
    @github_user = github_client.user

    @github_user
  end

  def github_username
    return github_user.login
  end
end
