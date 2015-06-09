class Build < ActiveRecord::Base
  belongs_to :project
  before_create :set_waiting
  before_create :set_number
  has_many :issues
  has_many :stats

  ## self.status is in {:waiting, :shutdown, :passed, :failed, :build_script_failed }

  def to_param
    self.number.to_s
  end

  # Only works on builds associated with pull requests
  def get_changed_files!
    client = self.project.github_client
    client.pull_request_files(self.project.full_name, self.pull_id)
  end

  # Only works on builds associated with pull requests
  def get_changed_filenames!
    get_changed_filesnames!.map(&:filename)
  end

  # Only works on builds associated with pull requests
  def get_changed_lines_by_file!
    get_changed_files!.reduce({}) do |files, file|
      files[file.filename] = GitDiffParser::Patch.new(file.patch).changed_lines.map(&:number); files
    end
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

  def in_progress?
    self.status == 'waiting' || self.status == 'queued'
  end

  protected
  def get_github_status
    return case self.status
    when "waiting" then :pending
    when "shutdown" then :error
    when "passed" then :success
    when "failed" then :failure
    when "build_script_failed" then :failure
    else :error end
  end

  def get_status_description
    return "Spearmint tests failed. Check details for more information."
  end

  def set_waiting
    self.status = :waiting
  end

  def set_number
    self.number = Build.where(project_id: self.project_id).count + 1
  end
end
