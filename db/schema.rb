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

ActiveRecord::Schema.define(version: 20191105212951) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "canvas_site_mailing_list_members", force: :cascade do |t|
    t.integer  "mailing_list_id",                             null: false
    t.string   "first_name",      limit: 255
    t.string   "last_name",       limit: 255
    t.string   "email_address",   limit: 255,                 null: false
    t.boolean  "can_send",                    default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "canvas_site_mailing_list_members", ["mailing_list_id", "email_address"], name: "mailing_list_membership_index", unique: true, using: :btree

  create_table "canvas_site_mailing_lists", force: :cascade do |t|
    t.string   "canvas_site_id",         limit: 255
    t.string   "canvas_site_name",       limit: 255
    t.string   "list_name",              limit: 255
    t.string   "state",                  limit: 255
    t.datetime "populated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "members_count"
    t.integer  "populate_add_errors"
    t.integer  "populate_remove_errors"
    t.string   "type",                   limit: 255
  end

  add_index "canvas_site_mailing_lists", ["canvas_site_id"], name: "index_canvas_site_mailing_lists_on_canvas_site_id", unique: true, using: :btree

  create_table "canvas_synchronization", force: :cascade do |t|
    t.datetime "last_guest_user_sync"
    t.datetime "latest_term_enrollment_csv_set"
    t.datetime "last_instructor_sync"
  end

  create_table "oauth2_data", force: :cascade do |t|
    t.string  "uid",             limit: 255
    t.string  "app_id",          limit: 255
    t.text    "access_token"
    t.text    "refresh_token"
    t.integer "expiration_time", limit: 8
    t.text    "app_data"
  end

  add_index "oauth2_data", ["uid", "app_id"], name: "index_oauth2_data_on_uid_app_id", unique: true, using: :btree

  create_table "oec_course_codes", force: :cascade do |t|
    t.string   "dept_name",      limit: 255, null: false
    t.string   "catalog_id",     limit: 255, null: false
    t.string   "dept_code",      limit: 255, null: false
    t.boolean  "include_in_oec",             null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "oec_course_codes", ["dept_code"], name: "index_oec_course_codes_on_dept_code", using: :btree
  add_index "oec_course_codes", ["dept_name", "catalog_id"], name: "index_oec_course_codes_on_dept_name_and_catalog_id", unique: true, using: :btree

  create_table "recent_uids", force: :cascade do |t|
    t.string   "owner_id",   limit: 255
    t.string   "stored_uid", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "recent_uids", ["owner_id"], name: "recent_uids_index", using: :btree

  create_table "saved_uids", force: :cascade do |t|
    t.string   "owner_id",   limit: 255
    t.string   "stored_uid", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "saved_uids", ["owner_id"], name: "saved_uids_index", using: :btree

  create_table "schema_migrations_backup", id: false, force: :cascade do |t|
    t.string "version", limit: 255
  end

  create_table "schema_migrations_fixed_backup", id: false, force: :cascade do |t|
    t.string "version", limit: 255
  end

  create_table "user_auths", force: :cascade do |t|
    t.string   "uid",                   limit: 255,                 null: false
    t.boolean  "is_superuser",                      default: false, null: false
    t.boolean  "active",                            default: false, null: false
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
    t.boolean  "is_viewer",                         default: false, null: false
    t.boolean  "is_canvas_whitelisted",             default: false, null: false
  end

  add_index "user_auths", ["uid"], name: "index_user_auths_on_uid", unique: true, using: :btree

  create_table "user_data", force: :cascade do |t|
    t.string   "uid",            limit: 255
    t.string   "preferred_name", limit: 255
    t.datetime "first_login_at"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "user_data", ["uid"], name: "index_user_data_on_uid", unique: true, using: :btree

  create_table "webcast_course_site_log", force: :cascade do |t|
    t.integer  "canvas_course_site_id",    null: false
    t.datetime "webcast_tool_unhidden_at", null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "webcast_course_site_log", ["canvas_course_site_id"], name: "webcast_course_site_log_unique_index", unique: true, using: :btree

end
