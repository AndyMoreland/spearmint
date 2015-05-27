namespace :docker do

  desc "Set environment variables needed by docker"
  task set_env: :environment do
    #`export DOCKER_HOST=TODO`
    #`export DOCKER_CERT_PATH=TODO`
    `export DOCKER_TLS_VERIFY=1`
  end

  desc "Set up docker stuff, probably"
  task init: :environment do
    `docker pull phusion/passenger-ruby22:latest`
    `docker tag phusion/passenger-ruby22:latest base:ruby22`
    `docker build -t spearmint #{Rails.root.join('lib', 'tasks')}`
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
