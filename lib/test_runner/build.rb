module TestRunner
  class Build

    attr_reader :project, :branch, :jobs
    
    def initialize project, branch, jobs
      @project = project
      @branch = branch
      @jobs = jobs
    end

    def fetch!
      owner, name = @project.title.split('/')
      
      client = Octokit::Client.new access_token: @project.github_token
      repo = client.repo(@project.title)
      url = repo.archive_url.sub('{archive_format}', 'tarball').sub('{/ref}', '/' + @branch)

      ### TODO: do more of this in ruby instead of shell ..?

      # parent_dir = Rails.root.join('clients', owner, name)
      @branch_dir = Rails.root.join('clients', owner, name, @branch)
      @tarball = @branch_dir + '.tar'

      `mkdir -p #{@branch_dir}`
      `curl -L #{url} > #{@tarball}`
      `tar xf #{@tarball} --directory #{@branch_dir} --strip-components=1`
      
      all_js = Rails.root.join('clients', owner, name, @branch, '**', '*.js')
      @files = Dir[all_js]
    end

    def cleanup!
      `rm -rf #{@branch_dir} #{@tarball}`
    end
    
    def execute!
      raise 'Build not yet fetched' unless @files
      @jobs.each { |job| job.execute!(@files) }
    end

    def success?
      @jobs.all? { |job| job.success? }
    end

    def issues
      @jobs.flat_map { |job| job.issues }
    end
  end
end
