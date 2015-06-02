require_relative 'docker'

module TestRunner
  class Job

    attr_writer :issues
    attr_writer :stats

    def sources
      raise 'abstract'
    end

    def execute!(sources)
      raise 'abstract'
    end

    def issues
      @issues or raise 'Job not yet run'
    end

    def stats
      @stats or raise 'Job not yet run'
    end

    def success?
      issues.none? { |issue| issue.fatal? }
    end

    class << self
      def relative_filename(build, full_filename)
        full_filename.sub(/#{Rails.root.join('clients', build.project.full_name, "#{build.commit}/")}/, '')
      end
    end
  end
end
