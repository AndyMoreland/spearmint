module TestRunner
  module Runnable

    def project_directory_path
      Rails.root.join('clients', project.full_name)
    end

    def build_directory_path
      Rails.root.join('clients', project.full_name, commit)
    end

    def build_tarball_path
      Rails.root.join('clients', project.full_name, "#{commit}.tar")
    end

    def build_js_wildcard_path
      Rails.root.join('clients', project.full_name, commit, '**', '*.js')
    end
    
    def fetch!
      client = Octokit::Client.new access_token: project.users.sample.client_token # load balancing lol
      repo = client.repo(project.full_name)
      url = repo.archive_url.sub('{archive_format}', 'tarball').sub('{/ref}', "/#{commit}")

      ### TODO: do more of this in ruby instead of shell ..?

      build_dir = build_directory_path
      tarball = build_tarball_path

      cmd = [%(mkdir -p "#{build_dir}"),
             %(curl -L "#{url}" > "#{tarball}"),
             %(tar xf "#{tarball}" --directory "#{build_dir}" --strip-components=1)
            ].map { |c| "(#{c})" }.join(' && ')

      `#{cmd}`
      @build_ready = true
    end

    def cleanup!
      `rm -rf #{build_directory_path} #{build_tarball_path}`
    end
    
    def execute!(jobs)
      raise 'Build not yet fetched' unless @build_ready
      @jobs = jobs
      @jobs.each { |job| job.execute!(self, Dir[build_js_wildcard_path]) }
    end

    def success?
      @jobs.all? { |job| job.success? }
    end

    def issues
      @jobs.flat_map { |job| job.issues }
    end
  end
end
