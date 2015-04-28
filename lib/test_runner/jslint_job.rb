require_relative 'job'
require_relative 'issue'

module TestRunner
  class JSLintJob < Job
    def execute!(sources)
      @issues = []
      sources.each do |src|
        result = `jslint #{src}`
        @issues.push Issue.new(file: src, message: result, fatal: false)
      end
    end
  end
end
