module BuildsHelper
  def dedupe_issues(issues, issues_seen)
    issues.select do |issue|
      print issues_seen; puts
      msg_without_numbers = reusable_issue_message issue.message
      puts msg_without_numbers
      unique_issue = !issues_seen[msg_without_numbers]
      issues_seen[msg_without_numbers] = true
      unique_issue
    end
  end

  def reusable_issue_message(full_msg)
    full_msg.gsub(/[0-9]+/, '*').strip
  end

  def pretty_print_status(status)
    status.gsub('_', ' ').titleize
  end
end
