module TestRunner
  class PylintJob < Job::Default

    def execute!(build)
      self.issues = []
      self.stats = []

      sources(build.project, build.commit, 'py').each do |src|
        result = Docker.run("pylint --output-format=json #{src}", build)
        next if result.empty?

        raw_issues = JSON.parse(result)
        contents = File.readlines src
        filename = Job.relative_filename(build, src)
        parsed_issues = raw_issues.reject { |i| i.nil? }.map { |issue| parse_issue(build, filename, contents, issue) }

        self.issues.concat parsed_issues
      end
    end

    def parse_issue(build, filename, contents, params)
      case params['type']
      when 'convention'
        issue = Issue::Convention.new
      when 'refactor'
        issue = Issue::Refactor.new
      when 'warning'
        issue = Issue::Warning.new
      when 'error'
        issue = Issue::Error.new
      when 'fatal'
        issue = Issue::Abort.new
      else
        raise '[PylintJob::parse_issue] unknown issue type'
      end

      issue.source = 'Pylint'
      issue.build_id = build.id
      issue.file = filename
      issue.line = params['line']
      issue.line_contents = contents[issue.line - 1]
      issue.character = params['column']
      issue.message = params['message']

      issue
    end
  end
end
