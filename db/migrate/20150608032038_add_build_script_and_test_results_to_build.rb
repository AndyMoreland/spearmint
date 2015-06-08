class AddBuildScriptAndTestResultsToBuild < ActiveRecord::Migration
  def change
    add_column :builds, :build_script_output, :text, null: true
    add_column :builds, :unit_tests_output, :text, null: true
    add_column :builds, :unit_tests_failed, :boolean, null: true
  end
end
