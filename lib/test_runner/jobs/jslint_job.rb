module TestRunner
  class JSLintJob < Job::Default

    def execute!(build)
      self.issues = []
      self.stats = []

      sources(build, 'js').each do |src|
        result = Docker.run("node #{Rails.root.join('node_modules', 'jslint', 'bin', 'jslint.js')} --json #{src}", build)
        next if result.empty?

        _, raw_issues = JSON.parse(result)
        contents = File.readlines src
        filename = Job.relative_filename(build, src)
        parsed_issues = raw_issues.reject { |i| i.nil? }.map { |issue| parse_issue(build, filename, contents, issue) }

        self.issues.concat parsed_issues
      end
    end

    def parse_issue(build, filename, contents, params)
      id = params['id']
      reason = params['reason']

      raise '[JSLintJob::parse_issue] malformed input, no issue id or reason' unless id or reason

      if reason && (reason.match(/^Stopping/) || reason.match(/^Too many errors/))
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
      else
        raise '[JSLintJob::parse_issue] unknown issue type'
      end

      issue.source = 'JSLint'
      issue.build_id = build.id
      issue.file = filename
      issue.line = params['line']
      issue.line_contents = contents[issue.line - 1] # lol indexing
      issue.character = params['character']
      issue.message = params['reason']

      issue
    end
  end
end
