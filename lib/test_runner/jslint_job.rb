require_relative 'job'

module TestRunner
  class JSLintJob < Job
    def execute!(build, sources)
      self.issues = []
      sources.each do |src|
        result = `jslint --json #{src}`
        file, raw_issues = JSON.parse(result)
        parsed_issues = raw_issues.reject { |i| i.nil? }.map { |issue| Issue.fromJSLint(build, file, issue) }
        
        self.issues.concat parsed_issues
      end
    end
  end
end
