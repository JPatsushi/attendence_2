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

ActiveRecord::Schema.define(version: 20181111155240) do

  create_table "locations", force: :cascade do |t|
    t.integer "lo_number"
    t.string "lo_name"
    t.string "lo_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "monthly_authentications", force: :cascade do |t|
    t.string "year"
    t.string "month"
    t.integer "certifier"
    t.integer "user_id"
    t.string "content"
    t.string "status", default: "未"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "time_cards", force: :cascade do |t|
    t.integer "year"
    t.integer "month"
    t.integer "day"
    t.datetime "in_at"
    t.datetime "out_at"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "remark"
    t.datetime "over_work"
    t.string "content"
    t.integer "certifer"
    t.string "status"
    t.integer "change_certifier"
    t.datetime "tmp_in_at"
    t.datetime "tmp_out_at"
  end

  create_table "time_infos", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "must_work_time"
    t.datetime "sd_work_time"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.string "remember_digest"
    t.boolean "admin", default: false
    t.string "activation_digest"
    t.boolean "activated", default: false
    t.datetime "activated_at"
    t.string "reset_digest"
    t.datetime "reset_sent_at"
    t.string "depart"
    t.boolean "superior", default: false
    t.integer "employee_number"
    t.string "uid"
    t.datetime "basic_work_time"
    t.datetime "designated_work_start_time"
    t.datetime "designated_work_end_time"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

end
