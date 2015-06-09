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
        pull_id: params[:pull_request][:number]
      )
    else
      @build = @project.builds.build(params[:build].try(:permit, :title, :commit))
      @build.commit = @project.github_client.repo(@project.full_name).rels[:commits].get.data.first.sha
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
    redirect_to(request.path, params: params, flash: { query: request.query_parameters } ) unless request.query_parameters.empty?
    @project_name = @project.name
    @build = @project.builds.find_by_number(params[:number])
    @should_dedupe_issues = flash[:query] and flash[:query]['dedupe']

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
    @all_issues = @build.issues.group_by(&:source).map do |test_name, issues|
      { test_name => issues.group_by(&:file).map { |file_name, issues|
         { file_name => issues.group_by(&:line) } }.reduce(:merge)
      }
    end
    @all_issues = @all_issues.reduce :merge
  end

  protected

  def load_project
    @project = Project.find(params[:project_id])

    render error: "can't find project" unless @project
  end
end
