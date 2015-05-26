class AddSourceToIssue < ActiveRecord::Migration
  def change
    add_column :issues, :source, :string
  end
end
