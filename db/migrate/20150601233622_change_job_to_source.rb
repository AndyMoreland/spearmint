class ChangeJobToSource < ActiveRecord::Migration
  def change
    rename_column :stats, :job, :source
  end
end
