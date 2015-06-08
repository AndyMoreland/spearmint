module BuildsHelper
  def dedupe_issues!(issues, issues_seen)
    issues.select! do |issue|
      print issues_seen; puts
      msg_without_numbers = issue.message.gsub(/\[.*\]/, '').strip
      puts msg_without_numbers
      unique_issue = !issues_seen[msg_without_numbers]
      issues_seen[msg_without_numbers] = true
      unique_issue
    end
  end
end
