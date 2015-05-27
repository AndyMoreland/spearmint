module TestRunner
  module Docker
    class << self
      def run(cmd, build)
        if ENV['SPEARMINT_DISABLE_DOCKER']
          puts "Docker is DISABLED. Running command locally..."
          return `#{cmd}`
        end
        
        dir = build.build_directory_path
        `docker run --rm -v #{dir}:#{mount_paths dir} spearmint #{mount_paths cmd}`
      end

      def mount_paths(abs_path)
        abs_path.to_s.gsub(Rails.root.to_s, '/spearmint')
      end
    end
  end
end
