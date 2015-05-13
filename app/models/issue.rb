class Issue < ActiveRecord::Base

  belongs_to :build

  class Error < Issue
  end
  
  class Warning < Issue
  end

  def self.errors
    where(type: Error)
  end

  def self.warnings
    where(type: Warning)
  end

  def self.fromJSLint(build, file, params)
    if !params
      return nil
    end

    if params and params.has_key?('id')
      rawtype = params['id'].gsub(/[()]/, '')
      case rawtype
      when 'error'
        issue = Error.new
      when 'warning'
        issue = Warning.new
      else
        issue = Issue.new
      end
    else
      issue = Issue.new
    end

    # Chop code dir, user dir, project dir, commit dir
    file_relative = file.sub(/#{Rails.root.join('clients', build.project.full_name, "#{build.commit}/")}/, '')
    
    issue.build_id = build.id
    issue.file = file_relative
    issue.line = params['line']
    issue.character = params['character']
    issue.message = params['reason']
    issue.fatal = params['id'] == '(error)'
    issue
  end
end


