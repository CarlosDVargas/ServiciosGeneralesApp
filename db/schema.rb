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

ActiveRecord::Schema[7.0].define(version: 2022_03_16_085153) do
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
  end

  create_table "feedbacks", force: :cascade do |t|
    t.text "observations", limit: 300
    t.integer "satisfaction"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.index ["employee_id"], name: "index_tasks_on_employee_id"
    t.index ["request_id"], name: "index_tasks_on_request_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "email"
    t.boolean "admin", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
  end

  add_foreign_key "deny_reasons", "requests"
  add_foreign_key "deny_reasons", "users"
  add_foreign_key "tasks", "employees"
  add_foreign_key "tasks", "requests"
end
