# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150609004738) do

  create_table "builds", force: :cascade do |t|
    t.string   "title"
    t.string   "status"
    t.integer  "project_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.string   "commit"
    t.integer  "pull_id"
    t.text     "build_script_output"
    t.text     "unit_tests_output"
    t.boolean  "unit_tests_failed"
    t.integer  "number",              null: false
  end

  add_index "builds", ["project_id", "number"], name: "index_builds_on_project_id_and_number", unique: true
  add_index "builds", ["project_id"], name: "index_builds_on_project_id"

  create_table "issues", force: :cascade do |t|
    t.string   "file"
    t.integer  "line"
    t.integer  "character"
    t.string   "message"
    t.boolean  "fatal"
    t.integer  "build_id"
    t.string   "type",          null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "line_contents"
    t.string   "source"
  end

  add_index "issues", ["build_id"], name: "index_issues_on_build_id"

  create_table "projects", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "full_name"
    t.integer  "github_id"
  end

  create_table "projects_users", force: :cascade do |t|
    t.integer "project_id"
    t.integer "user_id"
  end

  add_index "projects_users", ["project_id"], name: "index_projects_users_on_project_id"
  add_index "projects_users", ["user_id"], name: "index_projects_users_on_user_id"

  create_table "settings", force: :cascade do |t|
    t.datetime "created_at",                                                    null: false
    t.datetime "updated_at",                                                    null: false
    t.integer  "project_id"
    t.integer  "user_with_token",                                               null: false
    t.string   "build_command"
    t.string   "test_command"
    t.integer  "concurrent_jobs", default: 2,                                   null: false
    t.text     "ignored_files",   default: "[\"node_modules\",\"jquery*.js\"]"
  end

  add_index "settings", ["project_id"], name: "index_settings_on_project_id"

  create_table "stats", force: :cascade do |t|
    t.string   "source"
    t.text     "data",       null: false
    t.integer  "build_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "file"
  end

  add_index "stats", ["build_id"], name: "index_stats_on_build_id"

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "provider"
    t.string   "uid"
    t.string   "client_secret"
    t.string   "client_token"
    t.datetime "expires_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
