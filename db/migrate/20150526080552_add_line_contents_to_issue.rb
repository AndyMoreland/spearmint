class AddLineContentsToIssue < ActiveRecord::Migration
  def change
    add_column :issues, :line_contents, :string
  end
end
