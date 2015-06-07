namespace :docker do

  desc "Set environment variables needed by docker"
  task set_env: :environment do
    #`export DOCKER_HOST=TODO`
    #`export DOCKER_CERT_PATH=TODO`
    `export DOCKER_TLS_VERIFY=1`
  end

  desc "Set up docker stuff, probably"
  task init: :environment do
    puts `docker pull phusion/passenger-ruby22:latest`
    puts `docker tag phusion/passenger-ruby22:latest base:ruby22`
    puts `docker build -t spearmint #{Rails.root.join('lib', 'tasks')}`
    puts `docker images`
  end

  desc "Update docker image to latest Spearmint build"
  task refresh: :environment do
    puts `docker rmi -f spearmint`
    puts `docker build -t spearmint #{Rails.root.join('lib', 'tasks')}`
    puts `docker images`
  end

  desc "Verify docker:init was successful"
  task verify: :environment do
    success = ['phusion/passenger-ruby22', 'base', 'spearmint'].map { |i| `docker images | grep #{i}` }.none? { |image| image.empty? }
    if success
      puts "You're good to go!"
    else
      puts "NOPE it didn't work. Debug manually. Trying :init again probably will not help."
    end
  end

  # TODO task init: :set_env

end
