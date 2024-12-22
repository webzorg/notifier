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

ActiveRecord::Schema[8.0].define(version: 2024_12_22_151801) do
  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.boolean "due_date_reminder_enabled", default: true, null: false
    t.integer "due_date_reminder_offset_in_days", default: 0, null: false
    t.time "due_date_reminder_time", default: "2000-01-01 07:00:00", null: false
    t.string "time_zone", limit: 30, default: "UTC", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end
end
