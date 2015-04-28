require_relative 'build'
require_relative 'jslint_job'

module TestRunner
  class BasicBuild < Build
    def initialize project, branch
      super project, branch, [ JSLintJob.new ]
    end
  end
end
