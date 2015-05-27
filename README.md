# Spearmint

### Setup

- Run `bundle install` to install project dependencies
- Install Docker. You're on your own for this one. On Mac I recommend `boot2docker`, available through homebrew. On Linux it's easy, Google it!
- Run `rake docker:init` once. Just once, it's slow: expect it to take about 10 minutes. There's no console output.
- Run `rake docker:verify` to check whether docker got initialized correctly.
- Run `rake test_runner:server` to run the test server
- Run `rails s` to run the web server
- Party

### Environment

- Docker is enabled by default because it's important.
- Run `export SPEARMINT_DISABLE_DOCKER=1` to disable Docker integration (e.g. if your Docker installation is in progress or broken)
- Run `unset SPEARMINT_DISABLE_DOCKER` to reenable it.
