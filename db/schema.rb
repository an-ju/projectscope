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

ActiveRecord::Schema.define(version: 2019_01_22_194102) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "configs", id: :serial, force: :cascade do |t|
    t.integer "project_id"
    t.string "metric_name"
    t.text "encrypted_options"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "encrypted_options_iv"
    t.string "metrics_params"
    t.string "token"
    t.index ["project_id"], name: "index_configs_on_project_id"
  end

  create_table "iterations", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "start_time"
    t.datetime "end_time"
    t.boolean "template"
    t.integer "project_id"
    t.boolean "active"
    t.index ["project_id"], name: "index_iterations_on_project_id"
  end

  create_table "metric_samples", id: :serial, force: :cascade do |t|
    t.integer "project_id"
    t.string "metric_name"
    t.text "encrypted_raw_data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "encrypted_raw_data_iv"
    t.float "score"
    t.jsonb "image"
    t.integer "data_version"
    t.index ["project_id", "metric_name"], name: "index_metric_samples_on_project_id_and_metric_name"
    t.index ["project_id"], name: "index_metric_samples_on_project_id"
  end

  create_table "ownerships", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "project_id"
    t.index ["project_id"], name: "index_ownerships_on_project_id"
    t.index ["user_id"], name: "index_ownerships_on_user_id"
  end

  create_table "project_issues", force: :cascade do |t|
    t.string "name"
    t.jsonb "evidence"
    t.text "content"
    t.bigint "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "data_version"
    t.index ["project_id"], name: "index_project_issues_on_project_id"
  end

  create_table "projects", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.index ["name"], name: "index_projects_on_name"
  end

  create_table "projects_users", id: false, force: :cascade do |t|
    t.integer "project_id"
    t.integer "user_id"
    t.index ["project_id"], name: "index_projects_users_on_project_id"
    t.index ["user_id"], name: "index_projects_users_on_user_id"
  end

  create_table "raw_data", force: :cascade do |t|
    t.string "name"
    t.jsonb "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "project_id"
    t.integer "data_version"
    t.index ["project_id"], name: "index_raw_data_on_project_id"
  end

  create_table "tasks", id: :serial, force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.string "task_status"
    t.integer "duration"
    t.string "task_callbacks"
    t.string "updater_type"
    t.datetime "update_time"
    t.string "updater_info"
    t.integer "iteration_id"
    t.index ["iteration_id"], name: "index_tasks_on_iteration_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "provider_username", default: "", null: false
    t.string "email", default: ""
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "provider"
    t.string "uid"
    t.string "role", default: "student", null: false
    t.text "preferred_metrics"
    t.integer "project_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["project_id"], name: "index_users_on_project_id"
    t.index ["provider_username"], name: "index_users_on_provider_username", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "whitelists", id: :serial, force: :cascade do |t|
    t.string "username"
    t.index ["username"], name: "index_whitelists_on_username"
  end

  add_foreign_key "iterations", "projects"
  add_foreign_key "project_issues", "projects"
  add_foreign_key "tasks", "iterations"
  add_foreign_key "users", "projects"
end
