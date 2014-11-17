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

ActiveRecord::Schema.define(version: 20141117110137) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "academic_levels", force: true do |t|
    t.string   "name",             limit: 100
    t.integer  "question_type_id"
    t.boolean  "published"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "ussd_id"
  end

  create_table "input_logs", force: true do |t|
    t.string   "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "trash"
  end

  create_table "parameters", force: true do |t|
    t.string   "sms_gateway_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "billing_url"
  end

  create_table "question_types", force: true do |t|
    t.string   "name",       limit: 100
    t.boolean  "published"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "ussd_id"
  end

  create_table "sessions", force: true do |t|
    t.string   "msisdn",            limit: 100
    t.integer  "subscription_id"
    t.integer  "question_type_id"
    t.integer  "academic_level_id"
    t.string   "sc",                limit: 100
    t.string   "session_id",        limit: 100
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "req_no"
    t.integer  "user_input"
  end

  add_index "sessions", ["msisdn"], name: "index_sessions_on_msisdn", using: :btree
  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", using: :btree

  create_table "subscriptions", force: true do |t|
    t.string   "name",       limit: 100
    t.integer  "duration"
    t.integer  "price"
    t.boolean  "published"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "ussd_id"
  end

end
