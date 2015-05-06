class PagesController < ApplicationController
  def index

    if user_signed_in?
      client = Octokit::Client.new(:access_token => current_user.client_token)
      user = client.user
      user.login
      @repos = user.rels[:repos].get.data
    end
    
  end
end
