# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2022_03_23_043604) do
  create_table "deny_reasons", force: :cascade do |t|
    t.string "description"
    t.integer "user_id", null: false
    t.integer "request_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["request_id"], name: "index_deny_reasons_on_request_id"
    t.index ["user_id"], name: "index_deny_reasons_on_user_id"
  end

  create_table "employees", force: :cascade do |t|
    t.string "idCard"
    t.string "fullName"
    t.string "email"
    t.boolean "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
  end

  create_table "feedbacks", force: :cascade do |t|
    t.text "observations", limit: 300
    t.integer "satisfaction"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "request_id", null: false
    t.index ["request_id"], name: "index_feedbacks_on_request_id"
  end

  create_table "observations", force: :cascade do |t|
    t.text "description"
    t.integer "user_id", null: false
    t.integer "task_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["task_id"], name: "index_observations_on_task_id"
    t.index ["user_id"], name: "index_observations_on_user_id"
  end

  create_table "requests", force: :cascade do |t|
    t.string "requester_name"
    t.string "requester_extension"
    t.string "requester_phone"
    t.string "requester_id"
    t.string "requester_mail"
    t.string "requester_type"
    t.string "student_id"
    t.string "student_assosiation"
    t.string "work_location"
    t.string "work_building"
    t.string "work_type"
    t.text "work_description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status", default: "pending"
  end

  create_table "tasks", force: :cascade do |t|
    t.integer "employee_id", null: false
    t.integer "request_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "started_at"
    t.datetime "finished_at"
    t.integer "time_duration"
    t.boolean "completed?"
    t.index ["employee_id"], name: "index_tasks_on_employee_id"
    t.index ["request_id"], name: "index_tasks_on_request_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "role", default: 0
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "deny_reasons", "requests"
  add_foreign_key "deny_reasons", "users"
  add_foreign_key "employees", "users"
  add_foreign_key "feedbacks", "requests"
  add_foreign_key "observations", "tasks"
  add_foreign_key "observations", "users"
  add_foreign_key "tasks", "employees"
  add_foreign_key "tasks", "requests"
end
