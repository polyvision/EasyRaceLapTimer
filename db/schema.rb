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

ActiveRecord::Schema.define(version: 20151028210025) do

  create_table "pilot_race_laps", force: :cascade do |t|
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "pilot_id",        limit: 4
    t.integer  "lap_num",         limit: 4
    t.integer  "lap_time",        limit: 4
    t.integer  "race_session_id", limit: 4
  end

  add_index "pilot_race_laps", ["lap_num"], name: "index_pilot_race_laps_on_lap_num", using: :btree
  add_index "pilot_race_laps", ["lap_time"], name: "index_pilot_race_laps_on_lap_time", using: :btree
  add_index "pilot_race_laps", ["pilot_id"], name: "index_pilot_race_laps_on_pilot_id", using: :btree

  create_table "pilots", force: :cascade do |t|
    t.string   "name",              limit: 255
    t.string   "image",             limit: 255
    t.string   "transponder_token", limit: 255
    t.datetime "deleted_at"
  end

  add_index "pilots", ["deleted_at"], name: "index_pilots_on_deleted_at", using: :btree

  create_table "race_sessions", force: :cascade do |t|
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "title",      limit: 255
    t.boolean  "active"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.string   "confirmation_token",     limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email",      limit: 255
    t.integer  "failed_attempts",        limit: 4,   default: 0,  null: false
    t.string   "unlock_token",           limit: 255
    t.datetime "locked_at"
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
