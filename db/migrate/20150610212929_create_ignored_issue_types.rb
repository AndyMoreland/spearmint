class CreateIgnoredIssueTypes < ActiveRecord::Migration
  def change
    create_table :ignored_issue_types do |t|
      t.references :project, index: true, foreign_key: true

      t.string :generic_message
    end
  end
end
