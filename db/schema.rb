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

ActiveRecord::Schema.define(version: 20141231140206) do

  create_table "anons", force: true do |t|
    t.integer  "anonuser_id"
    t.integer  "anonmicropost_id"
    t.integer  "anonnum"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "chatmsgs", force: true do |t|
    t.string   "title"
    t.string   "content"
    t.string   "topshow"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "msgtype"
  end

  create_table "comments", force: true do |t|
    t.text     "msg"
    t.integer  "micropost_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.boolean  "visible",      default: true
    t.string   "anonid",       default: "0"
  end

  create_table "goodrelations", force: true do |t|
    t.integer  "good_id"
    t.integer  "begood_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "goodrelations", ["good_id", "begood_id"], name: "index_goodrelations_on_good_id_and_begood_id", unique: true, using: :btree

  create_table "microposts", force: true do |t|
    t.text     "content"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "stock_id"
    t.boolean  "visible",    default: true
    t.string   "image"
    t.integer  "anonnum",    default: 1
  end

  add_index "microposts", ["user_id", "created_at"], name: "index_microposts_on_user_id_and_created_at", using: :btree

  create_table "pmsgs", force: true do |t|
    t.integer  "fromuser_id"
    t.integer  "touser_id"
    t.text     "msg"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "anonnum"
    t.integer  "anontonum"
  end

  create_table "stocks", force: true do |t|
    t.string   "code"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tests", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "unreadmsgs", force: true do |t|
    t.integer  "msgfrom_id"
    t.integer  "msgto_id"
    t.integer  "msgunread",  default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "unreadrelations", force: true do |t|
    t.integer  "unreaduser_id"
    t.integer  "unreadmicropost_id"
    t.integer  "unread"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "phone"
    t.text     "password_digest"
    t.boolean  "email_confirmed"
    t.string   "remember_token"
    t.string   "password_reset_token"
    t.datetime "password_sent_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "mobile_toke"
    t.boolean  "admin",                default: false
    t.integer  "anonnum",              default: 1
  end

end
