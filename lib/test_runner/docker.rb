module TestRunner
  module Docker
    class << self
      def run(cmd, build, verbose: false)
        if ENV['SPEARMINT_DISABLE_DOCKER']
          out = `#{cmd}`
        else
          dir = build.build_directory_path
          out = `docker run --rm -v #{dir}:#{mount_paths dir} #{build.build_image_name} /bin/bash -c "#{mount_paths cmd}"`
        end
        retcode = $?.to_i
        return { error: retcode, output: out } if verbose
        out
      end

      def image(cmd, build, base: :spearmint, verbose: false)
        if ENV['SPEARMINT_DISABLE_DOCKER']
          out = `#{cmd}`
          retcode = $?.to_i
        else
          name = build.build_image_name
          dir = build.build_directory_path

          out = `docker run -v #{dir}:#{mount_paths dir} --name #{name}-container #{base} /bin/bash -c "#{mount_paths cmd}"`
          retcode = $?.to_i
          `docker commit #{name}-container #{name}`
          `docker rm -f #{name}-container`
        end

        return { error: retcode, output: out } if verbose
        out
      end

      def cleanup(build)
        `docker rmi -f #{build.build_image_name}` unless ENV['SPEARMINT_DISABLE_DOCKER']
      end

      def mount_paths(abs_path)
        abs_path.to_s.gsub(Rails.root.to_s, '/spearmint')
      end
    end
  end
end
