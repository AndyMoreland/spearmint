class ChangeTypeToIssueType < ActiveRecord::Migration
  def change
    rename_column :issues, :type, :issue_type
  end
end
