class ReportsController < ApplicationController
  before_filter :authenticate_user!

  def index
    show # FIXME NO
    source, _ = @reports.detect { |source, report| !report.nil? }
    unless source.nil?
      redirect_to project_report_path(@project, source)
    end
  end

  def show
    @project = Project.find(params[:project_id])
    @source = params[:source]

    # FIXME very error prone and nonrobust queries
    # most recent build
    @build = @project.builds.finished.order(:created_at).includes(:stats).last

    if @build.nil?
      @reports = {}
    else
      @reports = {
        "rubysadist" => rubysadist_report,
        "jscomplexity" => jscomplexity_report
      }
    end
    @report = @reports[@source]
  end

  private

  def jscomplexity_report
    @build.stats.where(source: 'JSComplexity').take
  end

  def rubysadist_report
    flay = @build.stats.where(source: 'RubyFlay').take
    flog = @build.stats.where(source: 'RubyFlog').take
    {
      "flay" => flay,
      "flog" => flog
    } if flay || flog
  end

end

