require 'pp'

class BuildsController < ApplicationController
  before_filter :load_project
  skip_before_action :verify_authenticity_token, only: :create

  def new
  end

  def create
    if params[:pull_request]
      @build = @project.builds.build(
        title: params[:pull_request][:title],
        commit: params[:pull_request][:head][:sha],
        pull_id: params[:pull_request][:number],
        author: params[:pull_request][:user][:login],
        message: params[:pull_request][:body],
        branch: params[:pull_request][:head][:ref]
      )
    else
      @build = @project.builds.build(params[:build].try(:permit, :title, :commit, :author, :message, :branch))
      commit = @project.github_client.commits(@project.full_name, params[:branch] || "master").first
      @build.branch ||= "master"
      @build.commit ||= commit.sha
      @build.author ||= commit.author.try :login
      @build.message ||= commit.commit.message
    end

    unless @build.save
      render error: "Can't find project with id #{params[:project_id]}"
    end

    flash[:notice] = "Created build."
    respond_to do |format|
      format.html { redirect_to(@project) }
      format.json { render status: 200, json: @build.to_json }
    end
  end

  def show
    @build = @project.builds.find_by_number(params[:number])

    respond_to do |f|
      f.html do
        redirect_to(request.path, params: params, flash: { query: request.query_parameters } ) unless request.query_parameters.empty?
        @should_dedupe_issues = flash[:query] and flash[:query]['dedupe']
        @all_issues = group_issues(@build.issues)
      end
      f.json { render json: @build.to_json }
    end
  end

  protected
  def load_project
    @project = Project.find(params[:project_id])

    render error: "can't find project" unless @project
  end

  # example format
  # --------------
  # {
  #   'jslint' =>
  #     { 'file.js' => [{ 1 => [issue1, issue2] },
  #                     { 8 => [issue3, issue4] }].
  #       'otherfile.js' => [{ 3 => [issue5, issue6] }] },
  #   'rubocop' =>
  #     { 'file.rb' => [{ 1 => [issue7] }] }
  # }
  def group_issues(issues)
    grouped_issues = issues.group_by(&:source).map do |test_name, issues|
      { test_name => issues.group_by(&:file).map { |file_name, issues|
          { file_name => issues.group_by(&:line) } }.reduce(:merge)
      }
    end

    grouped_issues.reduce(:merge)
  end
end
