# Spearmint

### Description

Spearmint is a GitHub-integrated code quality service. Coding standards are important, but no one reads style guides--and linters are a pain to configure and easy to forget about. Enter Spearmint: just sign up with GitHub and choose projects to watch. Spearmint will automatically run code quality checks on every pull request inside a secure, private virtual machine and display the results directly on the GitHub pull request page, no interaction needed. For devs looking to go the extra mile, Spearmint also provides a web application that allows users to tweak settings, see more detailed failure reports, and keep an eye on code quality statistics like cyclomatic complexity. Spearmint: freshen up your code!

### Setup

- Run `bundle install` to install project dependencies
- Install Docker. You're on your own for this one. On Mac I recommend `boot2docker`, available through homebrew (see below). On Linux it's easy, Google it!
- Run `rake docker:init` once. Just once, it's slow: expect it to take about 10 minutes. There's no console output.
- Run `rake docker:verify` to check whether docker got initialized correctly.
- Run `rake test_runner:server` to run the test server
- Run `rails s` to run the web server
- Party 🎉

#### Installing Docker on OSX

 - Make sure homebrew is installed and working
 - Install VirtualBox from the Oracle website
 - Run `brew install boot2docker` to install `boot2docker`
 - Run `boot2docker init` to initialize the installation
 - Run `boot2docker start` to start the Docker daemon, then export the environmental variables specified. You may choose to add these export commands to your shell startup file.

### Environment

- Docker is enabled by default because it's important.
- Run `export SPEARMINT_DISABLE_DOCKER=1` to disable Docker integration (e.g. if your Docker installation is in progress or broken)
- Run `unset SPEARMINT_DISABLE_DOCKER` to reenable it.
