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

  # TODO task init: :set_env

end
