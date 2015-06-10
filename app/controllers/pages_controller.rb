class PagesController < ApplicationController
  helper_method :is_watching

  def index
    Octokit.auto_paginate = true
    if user_signed_in?
      @repos = github_client.repos
    end
    Octokit.auto_paginate = false
  end

  def landing
  end

  def stop_watching_project

  end

  private

  def is_watching(repo)
    return current_user.projects.any? {|p| p.github_id == repo.id}
  end
end
