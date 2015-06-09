require 'json'
require_relative 'job'

module TestRunner
  class Job
    class Default < Job

      def sources(project, commit, extension)
        begin
          ignored = JSON.parse(project.setting.ignored_files || "[]").reject { |p| p.empty? }
        rescue JSON::ParserError
          ignored = []
        else
          ignored = [] unless ignored.is_a? Array
        end
        relatives = ignored.select { |p| p[0] == '/' }
        globals = ignored - relatives

        ignore_globs = (globals.map { |p| "./**/#{p}" }.concat relatives.map { |p| ".#{p}" }).map do |glob|
          Rails.root.join 'clients', project.full_name, commit, glob
        end

        all_files = Dir[Rails.root.join 'clients', project.full_name, commit, '**', "*.#{extension}"]
        ignored_files = ignore_globs.flat_map { |g| Dir[g] }

        all_files - ignored_files
      end

      class << self
        def jobs
          @job_klasses ||= load_jobs
          @job_klasses.map { |k| k.new }
        end

        def load_jobs
          Dir[Rails.root.join 'lib', 'test_runner', 'jobs', '*.rb'].each { |job_file| require job_file }
          ObjectSpace.each_object(self.singleton_class).to_a.reject { |k| k == Default }
        end
      end

    end
  end
end
