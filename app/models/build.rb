class Build < ActiveRecord::Base
  belongs_to :project
  before_create :set_waiting
  has_many :issues
  has_many :stats

  ## self.status is in {:waiting, :shutdown, :passed, :failed }

  def get_changed_files!
    client = self.project.github_client
    client.pull_request_files(self.project.full_name, self.pull_id).map(&:filename)
  end
  
  def sync_status_to_github!
    puts "[info] Synchronizing status to github, #{self.project.full_name}, #{self.commit}, #{self.get_github_status}, #{self.get_status_description}, #{self.status}"
    client = self.project.github_client
    client.create_status(self.project.full_name,
                         self.commit,
                         self.get_github_status,
                         context: 'spearmint',
                         target_url: "http://spearmint.ngrok.io/projects/#{self.project.id}/builds/#{self.id}",
                         description: self.get_status_description)
  end


  protected
  def get_github_status
    return case self.status
    when "waiting" then :pending
    when "shutdown" then :error
    when "passed" then :success
    when "failed" then :failure
    else :error end
  end

  def get_status_description
    return "Spearmint tests failed. Check details for more information."
  end
  
  def set_waiting
    self.status = :waiting
  end
end
