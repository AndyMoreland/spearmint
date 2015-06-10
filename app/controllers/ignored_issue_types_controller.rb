class IgnoredIssueTypesController < ApplicationController
  include BuildsHelper

  def create
    puts params
    proj_id = params['project_id'].to_i
    msg = reusable_issue_message params['issue']['message']
    ignored = IgnoredIssueType.where(project_id: proj_id, generic_message: msg)
    if ignored.empty?
      ignored = IgnoredIssueType.create(project_id: proj_id, generic_message: msg)
      Project.find(proj_id).builds.flat_map(&:issues).each do |issue|
        issue.destroy if reusable_issue_message(issue.message) == msg
      end
    end


    redirect_to request.referrer
  end

  def destroy
  end

  def destroy_all
  end
end
