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

ActiveRecord::Schema.define(version: 20160830071811) do

  create_table "config_values", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.string "value"
  end

  create_table "custom_soundfiles", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "title"
    t.string "file"
  end

  create_table "pilot_race_laps", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.integer  "pilot_id"
    t.integer  "lap_num"
    t.integer  "lap_time"
    t.integer  "race_session_id"
    t.datetime "deleted_at"
    t.boolean  "latest"
    t.boolean  "invalidated",     default: false
    t.integer  "merged_with_id"
    t.index ["deleted_at"], name: "index_pilot_race_laps_on_deleted_at", using: :btree
    t.index ["lap_num"], name: "index_pilot_race_laps_on_lap_num", using: :btree
    t.index ["lap_time"], name: "index_pilot_race_laps_on_lap_time", using: :btree
    t.index ["pilot_id"], name: "index_pilot_race_laps_on_pilot_id", using: :btree
  end

  create_table "pilots", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.string   "image"
    t.string   "transponder_token"
    t.datetime "deleted_at"
    t.string   "quad"
    t.string   "team"
    t.index ["deleted_at"], name: "index_pilots_on_deleted_at", using: :btree
  end

  create_table "race_attendees", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "race_session_id"
    t.integer "pilot_id"
    t.string  "transponder_token"
  end

  create_table "race_event_group_entries", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "token"
    t.integer  "pilot_id"
    t.integer  "race_event_group_id"
    t.integer  "fastest_lap_time",    default: 0
    t.integer  "total_time",          default: 0
    t.integer  "placement",           default: 0
  end

  create_table "race_event_groups", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.integer  "race_event_id"
    t.integer  "group_no"
    t.integer  "placement"
    t.integer  "points"
    t.integer  "heat_no",         default: 0
    t.boolean  "heat_done",       default: false
    t.integer  "race_session_id"
    t.boolean  "current",         default: false
    t.index ["placement"], name: "index_race_event_groups_on_placement", using: :btree
    t.index ["points"], name: "index_race_event_groups_on_points", using: :btree
    t.index ["race_event_id"], name: "index_race_event_groups_on_race_event_id", using: :btree
  end

  create_table "race_events", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.string   "title"
    t.integer  "number_of_pilots_per_group", default: 4
    t.boolean  "active",                     default: true
    t.integer  "number_of_heats",            default: 4
    t.integer  "current_heat",               default: 1
    t.integer  "next_heat_grouping_mode",    default: 0
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_race_events_on_deleted_at", using: :btree
  end

  create_table "race_sessions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.string   "title"
    t.boolean  "active"
    t.integer  "mode",                       default: 0
    t.integer  "max_laps",                   default: 0
    t.datetime "deleted_at"
    t.integer  "num_satellites",             default: 0
    t.integer  "time_penalty_per_satellite", default: 2500
    t.boolean  "hot_seat_enabled",           default: false
    t.integer  "idle_time_in_seconds",       default: 0
    t.index ["deleted_at"], name: "index_race_sessions_on_deleted_at", using: :btree
  end

  create_table "roles", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.string   "resource_type"
    t.integer  "resource_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id", using: :btree
    t.index ["name"], name: "index_roles_on_name", using: :btree
  end

  create_table "satellite_check_points", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "race_session_id"
    t.integer  "race_attendee_id"
    t.integer  "num_lap",          default: 0
    t.index ["race_attendee_id"], name: "index_satellite_check_points_on_race_attendee_id", using: :btree
    t.index ["race_session_id"], name: "index_satellite_check_points_on_race_session_id", using: :btree
  end

  create_table "soundfiles", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.string "file"
  end

  create_table "style_settings", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "own_logo_image"
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "email",                  default: "",   null: false
    t.string   "encrypted_password",     default: "",   null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,    null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",        default: 0,    null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.integer  "pin_code",               default: 1234
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  create_table "users_roles", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "user_id"
    t.integer "role_id"
    t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id", using: :btree
  end

end
