class Project < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_many :builds
  has_one :setting

  after_create :create_settings
  after_create :add_webhook!

  def github_url
    "https://github.com/#{full_name}"
  end

  # TOOD? (andymo) do we need to login this client?
  def github_client
    Octokit::Client.new access_token: self.setting.user_with_token.client_token
  end

  def allowed_to_webhook?
  end

  def add_webhook!
    return unless allowed_to_webhook?
    
    github_client.create_hook(self.full_name,
                              'web',
                              { url: "http://spearmint.com/hooks/#{self.id}", content_type: 'json' },
                              {
                               events: ['pull_request'],
                               active: true
                              })
  end

  private

  def create_settings
    Setting.create(project_id: self.id, user_with_token: self.users.last)
  end
end
