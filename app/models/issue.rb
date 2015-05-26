class Issue < ActiveRecord::Base

  belongs_to :build

  class Warning < Issue
    def initialize
      super
      self.fatal = false
    end
  end

  class Error < Issue
    def initialize
      super
      self.fatal = true
    end
  end

  class Abort < Issue
    def initialize
      super
      self.fatal = true
    end
  end

  def self.errors
    where(type: Error)
  end

  def self.warnings
    where(type: Warning)
  end

  def self.aborts
    where(type: Abort)
  end

  def self.fromJSLint(build, file, params)
    id = params['id']
    reason = params['reason']

    raise '[Issue::fromJSLint] malformed input, no issue id or reason' unless id or reason
    
    if reason && reason.match(/^Stopping/)
      issue = Abort.new
    elsif id
      rawtype = id.gsub(/[()]/, '')
      case rawtype
      when 'error'
        issue = Error.new
      when 'warning'
        issue = Warning.new
      else
        raise '[Issue::fromJSlint] unknown issue type'
      end
    end

    # Chop code dir, user dir, project dir, commit dir
    file_relative = file.sub(/#{Rails.root.join('clients', build.project.full_name, "#{build.commit}/")}/, '')
    issue.build_id = build.id
    issue.file = file_relative
    issue.line = params['line']
    issue.character = params['character']
    issue.message = params['reason']
    
    issue
  end

  def add_to_github(client, repo, pull_id, commit_sha)
    client.create_pull_request_comment(
                                       repo.full_name,
                                       pull_id,
                                       self.message,
                                       commit_sha,
                                       self.file,
                                       self.line,
                                      )
  end
end


