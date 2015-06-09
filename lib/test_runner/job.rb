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
        overlap = longest_overlap(build.build_directory_path.to_s + '/', full_filename)
        full_filename.sub(overlap, '')
      end

      protected
      def longest_overlap(left, right)
        overlap = ''
        for i in (0...left.length).to_a.reverse do
          suffix = left[i..-1]
          if right.match(/^#{suffix}/)
            overlap = suffix
          end
        end
        overlap
      end

    end
  end
end
