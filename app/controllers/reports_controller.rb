class ReportsController < ApplicationController
    before_filter :authenticate_user!

    def index
        show # FIXME NO
        source, _ = @has_report.detect { |source, has_report| has_report }
        unless source.nil?
            redirect_to project_report_path(@project, source)
        end
    end

    def show
        @project = Project.find(params[:project_id])
        @source = params[:source]
        @source_full_name = {
            "rubysadist" => "Ruby Sadist",
            "jscomplexity" => "JSComplexity"
        };

        # FIXME very error prone and nonrobust querie(s)
        # most recent build
        @build = @project.builds.finished.order(:created_at).includes(:stats).last

        @flay_report = @build.stats.where(source: 'RubyFlay').take unless @build.nil?
        @flog_report = @build.stats.where(source: 'RubyFlog').take unless @build.nil?
        @js_stats = @build.stats.where(source: 'JSComplexity').take unless @build.nil?

        @has_report = {
            "rubysadist" => (!@flay_report.nil? || !@flog_report.nil?),
            "jscomplexity" => !@js_stats.nil?
        }
    end


end
