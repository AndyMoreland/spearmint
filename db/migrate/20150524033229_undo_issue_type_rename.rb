class UndoIssueTypeRename < ActiveRecord::Migration
  def change
    rename_column :issues, :issue_type, :type
  end
end
