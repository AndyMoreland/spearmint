module TestRunner
  class JSLintJob < Job::Default
    
    def execute!(build)
      self.issues = []
      sources(build.project, build.commit, 'js').each do |src|
        result = `node #{Rails.root.join('node_modules', 'jslint', 'bin', 'jslint.js')} --json #{src}`
        file, raw_issues = JSON.parse(result)
        parsed_issues = raw_issues.reject { |i| i.nil? }.map { |issue| parse_issue(build, file, issue) }
        
        self.issues.concat parsed_issues
      end
    end

    def parse_issue(build, file, params)
      id = params['id']
      reason = params['reason']

      raise '[JSLintJob::parse_issue] malformed input, no issue id or reason' unless id or reason
      
      if reason && reason.match(/^Stopping/)
        issue = Issue::Abort.new
      elsif id
        rawtype = id.gsub(/[()]/, '')
        case rawtype
        when 'error'
          issue = Issue::Error.new
        when 'warning'
          issue = Issue::Warning.new
        else
          raise '[JSLintJob::parse_issue] unknown issue type'
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
  end
end
