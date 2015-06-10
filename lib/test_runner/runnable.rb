require 'fileutils'

module TestRunner
  module Runnable

    def build_directory_path(*args)
      Rails.root.join('clients', project.full_name, number.to_s, commit, *args)
    end

    def build_tarball_path
      Rails.root.join('clients', project.full_name, number.to_s, "#{commit}.tar")
    end

    def build_image_name
      "#{project.full_name.downcase.gsub('/','-')}-#{commit}-#{number}"
    end

    def fetch!
      client = project.github_client # load balancing lol
      repo = client.repo(project.full_name)
      url = repo.archive_url.sub('{archive_format}', 'tarball').sub('{/ref}', "/#{commit}")

      ### TODO: do more of this in ruby instead of shell to prevent bash injection haxxors ..?

      build_dir = build_directory_path
      tarball = build_tarball_path

      `mkdir -p "#{build_dir}"`

      cmd = [%(curl -L "#{url}" > "#{tarball}"),
             %(tar xf "#{tarball}" --directory "#{build_dir}" --strip-components=1)
            ].map { |c| "(#{c})" }.join(' && ')

      Docker.image(cmd, self)
      @files_ready = true
    end

    def rm_ignored!
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
        build_directory_path(glob)
      end

      ignored_files = ignore_globs.flat_map { |g| Dir[g] }.join ' '
      Docker.image("rm -rf #{ignored_files}", self)
    end

    def cleanup!
      Docker.cleanup(self)
      `rm -rf #{build_directory_path} #{build_tarball_path}`
    end

    def build!
      raise 'Files not yet present' unless @files_ready
      build_cmd = "cd #{build_directory_path}; #{self.project.setting.build_command}"
      if build_cmd
        results = Docker.image build_cmd, self, base: self.build_image_name, verbose: true
        self.build_script_output = results[:output]
        if results[:error] != 0
          self.status = :build_script_failed
          return
        end
      end
      @build_ready = true
    end

    def test!
      raise 'Build not yet compiled' unless @build_ready
      test_cmd = "cd #{build_directory_path}; #{self.project.setting.test_command}"
      if test_cmd
        results = Docker.run test_cmd, self, verbose: true
        self.unit_tests_output = results[:output]
        self.unit_tests_failed = (results[:error] != 0)
      end
    end

    def execute!(jobs)
      raise 'Build not yet compiled' unless @build_ready
      @jobs = jobs

      @jobs.each { |job| job.execute!(self) }
    end

    def success?
      !self.unit_tests_failed && @jobs.all? { |job| job.success? }
    end

    def issues
      @jobs.flat_map { |job| job.issues }
    end

    def stats
      @jobs.flat_map { |job| job.stats }
    end
  end
end
