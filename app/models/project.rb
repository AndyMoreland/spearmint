class Project < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_many :builds
  has_one :setting

  after_create :create_settings
  after_create :add_webhook!
  before_destroy :remove_webhook!

  def github_url
    "https://github.com/#{full_name}"
  end

  # TOOD? (andymo) do we need to login this client?
  def github_client
    Octokit::Client.new access_token: self.setting.user_with_token.client_token
  end

  def allowed_to_webhook?
    owner = github_client.repo(self.full_name).owner

    if owner.type == "Organization"
      return true
    elsif owner.type == "User"
      return owner.login == self.setting.user_with_token.github_login
    end
  end

  def add_webhook!
    return false unless allowed_to_webhook?
    
    hook = github_client.create_hook(self.full_name,
                                     'web',
                                     { url: "http://spearmint.com/hooks/#{self.id}", content_type: 'json' },
                                     {
                                      events: ['pull_request'],
                                      active: true
                                     })

    self.webhook_id = hook.id
    self.save
  end

  def remove_webhook!
    github_client.remove_hook(self.full_name, self.webhook_id) if self.webhook_id
  end

  private
  def create_settings
    Setting.create(project_id: self.id, user_with_token: self.users.last)
  end
end
