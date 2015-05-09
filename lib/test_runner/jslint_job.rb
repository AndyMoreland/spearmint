require_relative 'job'

module TestRunner
  class JSLintJob < Job
    def execute!(build, sources)
      self.issues = []
      sources.each do |src|
        result = `jslint --json #{src}`
        file, issues = JSON.parse(result)
        self.issues.concat(issues.map { |issue| Issue.fromJSLint(build, file, issue) })
      end
    end
  end
end
