class PagesController < ApplicationController
  def index
    if user_signed_in?
      @repos = github_user.rels[:repos].get.data
      @user_watchlist = Set.new(current_user.projects.map { |p| p.full_name })
    end
  end
end
