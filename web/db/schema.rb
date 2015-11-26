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

ActiveRecord::Schema.define(version: 20151125135718) do

  create_table "config_values", force: :cascade do |t|
    t.string "name"
    t.string "value"
  end

  create_table "pilot_race_laps", force: :cascade do |t|
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "pilot_id"
    t.integer  "lap_num"
    t.integer  "lap_time"
    t.integer  "race_session_id"
    t.datetime "deleted_at"
  end

  add_index "pilot_race_laps", ["deleted_at"], name: "index_pilot_race_laps_on_deleted_at"
  add_index "pilot_race_laps", ["lap_num"], name: "index_pilot_race_laps_on_lap_num"
  add_index "pilot_race_laps", ["lap_time"], name: "index_pilot_race_laps_on_lap_time"
  add_index "pilot_race_laps", ["pilot_id"], name: "index_pilot_race_laps_on_pilot_id"

  create_table "pilots", force: :cascade do |t|
    t.string   "name"
    t.string   "image"
    t.string   "transponder_token"
    t.datetime "deleted_at"
    t.string   "quad"
  end

  add_index "pilots", ["deleted_at"], name: "index_pilots_on_deleted_at"

  create_table "race_sessions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "title"
    t.boolean  "active"
  end

  create_table "soundfiles", force: :cascade do |t|
    t.string "name"
    t.string "file"
  end

  create_table "style_settings", force: :cascade do |t|
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "own_logo_image"
  end

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
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",        default: 0,  null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
