class Project < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_many :builds

  def github_url
    "https://github.com/#{full_name}"
  end

  # TOOD? (andymo) do we need to login this client?
  def github_client
    Octokit::Client.new access_token: self.users.sample.client_token
  end

  def add_webhook
    github_client.create_hook(self.full_name,
                              'web',
                              { url: 'foo', content_type: 'json' },
                              {
                               events: ['pull_request'],
                               active: true
                              })
  end
end
