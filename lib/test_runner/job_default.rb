require 'json'
require_relative 'job'

module TestRunner
  class Job
    class Default < Job

      def sources(build, extension)
        Dir[build.build_directory_path('**', "*.#{extension}")]
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
