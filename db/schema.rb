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

ActiveRecord::Schema.define(version: 20150712064069) do

  create_table "advices", force: true do |t|
    t.string   "title"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "anons", force: true do |t|
    t.integer  "anonuser_id"
    t.integer  "anonmicropost_id"
    t.integer  "anonnum"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "answers", force: true do |t|
    t.integer  "question_id"
    t.text     "text"
    t.text     "short_text"
    t.text     "help_text"
    t.integer  "weight"
    t.string   "response_class"
    t.string   "reference_identifier"
    t.string   "data_export_identifier"
    t.string   "common_namespace"
    t.string   "common_identifier"
    t.integer  "display_order"
    t.boolean  "is_exclusive"
    t.integer  "display_length"
    t.string   "custom_class"
    t.string   "custom_renderer"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "default_value"
    t.string   "api_id"
    t.string   "display_type"
    t.string   "input_mask"
    t.string   "input_mask_placeholder"
    t.string   "original_choice"
    t.boolean  "is_comment",             default: false
    t.integer  "column_id"
  end

  add_index "answers", ["api_id"], name: "uq_answers_api_id", unique: true, using: :btree

  create_table "chatmsgs", force: true do |t|
    t.string   "title"
    t.string   "content"
    t.string   "topshow"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "msgtype"
  end

  create_table "columns", force: true do |t|
    t.integer  "question_group_id"
    t.text     "text"
    t.text     "answers_textbox"
    t.datetime "created_at"
    t.datetime "updated_at"
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

  create_table "dependencies", force: true do |t|
    t.integer  "question_id"
    t.integer  "question_group_id"
    t.string   "rule"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "dependency_conditions", force: true do |t|
    t.integer  "dependency_id"
    t.string   "rule_key"
    t.integer  "question_id"
    t.string   "operator"
    t.integer  "answer_id"
    t.datetime "datetime_value"
    t.integer  "integer_value"
    t.float    "float_value"
    t.string   "unit"
    t.text     "text_value"
    t.string   "string_value"
    t.string   "response_other"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "column_id"
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
    t.integer  "randint",    default: 0
    t.integer  "microtype",  default: 0
  end

  add_index "microposts", ["user_id", "created_at"], name: "index_microposts_on_user_id_and_created_at", using: :btree

  create_table "mystocks", force: true do |t|
    t.integer  "user_id"
    t.integer  "stock_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pmsgs", force: true do |t|
    t.integer  "fromuser_id"
    t.integer  "touser_id"
    t.text     "msg"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "anonnum"
    t.integer  "anontonum"
  end

  create_table "question_groups", force: true do |t|
    t.text     "text"
    t.text     "help_text"
    t.string   "reference_identifier"
    t.string   "data_export_identifier"
    t.string   "common_namespace"
    t.string   "common_identifier"
    t.string   "display_type"
    t.string   "custom_class"
    t.string   "custom_renderer"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "api_id"
  end

  add_index "question_groups", ["api_id"], name: "uq_question_groups_api_id", unique: true, using: :btree

  create_table "questions", force: true do |t|
    t.integer  "survey_section_id"
    t.integer  "question_group_id"
    t.text     "text"
    t.text     "short_text"
    t.text     "help_text"
    t.string   "pick"
    t.string   "reference_identifier"
    t.string   "data_export_identifier"
    t.string   "common_namespace"
    t.string   "common_identifier"
    t.integer  "display_order"
    t.string   "display_type"
    t.boolean  "is_mandatory"
    t.integer  "display_width"
    t.string   "custom_class"
    t.string   "custom_renderer"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "correct_answer_id"
    t.string   "api_id"
    t.boolean  "modifiable",             default: true
    t.boolean  "dynamically_generate",   default: false
    t.string   "dummy_blob"
    t.string   "dynamic_source"
    t.string   "report_code"
    t.boolean  "is_comment",             default: false
  end

  add_index "questions", ["api_id"], name: "uq_questions_api_id", unique: true, using: :btree

  create_table "replyrelationships", force: true do |t|
    t.integer  "replyuser_id"
    t.integer  "replymicropost_id"
    t.integer  "replyunread"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "response_sets", force: true do |t|
    t.integer  "user_id"
    t.integer  "survey_id"
    t.string   "access_code"
    t.datetime "started_at"
    t.datetime "completed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "api_id"
    t.boolean  "test_data",    default: false
  end

  add_index "response_sets", ["access_code"], name: "response_sets_ac_idx", unique: true, using: :btree
  add_index "response_sets", ["api_id"], name: "uq_response_sets_api_id", unique: true, using: :btree

  create_table "responses", force: true do |t|
    t.integer  "response_set_id"
    t.integer  "question_id"
    t.integer  "answer_id"
    t.datetime "datetime_value"
    t.integer  "integer_value"
    t.float    "float_value"
    t.string   "unit"
    t.text     "text_value"
    t.string   "string_value"
    t.string   "response_other"
    t.string   "response_group"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "survey_section_id"
    t.string   "api_id"
    t.string   "blob"
    t.integer  "column_id"
  end

  add_index "responses", ["api_id"], name: "uq_responses_api_id", unique: true, using: :btree
  add_index "responses", ["survey_section_id"], name: "index_responses_on_survey_section_id", using: :btree

  create_table "rows", force: true do |t|
    t.integer  "question_group_id"
    t.string   "text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "stocks", force: true do |t|
    t.string   "code"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "shortname",  default: ""
  end

  create_table "survey_sections", force: true do |t|
    t.integer  "survey_id"
    t.string   "title"
    t.text     "description"
    t.string   "reference_identifier"
    t.string   "data_export_identifier"
    t.string   "common_namespace"
    t.string   "common_identifier"
    t.integer  "display_order"
    t.string   "custom_class"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "modifiable",             default: true
  end

  create_table "survey_translations", force: true do |t|
    t.integer  "survey_id"
    t.string   "locale"
    t.text     "translation"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "surveys", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.string   "access_code"
    t.string   "reference_identifier"
    t.string   "data_export_identifier"
    t.string   "common_namespace"
    t.string   "common_identifier"
    t.datetime "active_at"
    t.datetime "inactive_at"
    t.string   "css_url"
    t.string   "custom_class"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "display_order"
    t.string   "api_id"
    t.integer  "survey_version",         default: 0
    t.boolean  "template",               default: false
    t.integer  "user_id"
  end

  add_index "surveys", ["access_code", "survey_version"], name: "surveys_access_code_version_idx", unique: true, using: :btree
  add_index "surveys", ["api_id"], name: "uq_surveys_api_id", unique: true, using: :btree

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

  create_table "userconfigs", force: true do |t|
    t.string   "name"
    t.string   "value"
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
    t.integer  "randint",              default: 0
    t.boolean  "apple_micro_push",     default: true
    t.boolean  "apple_reply_push",     default: true
    t.boolean  "apple_chat_push",      default: true
  end

  create_table "validation_conditions", force: true do |t|
    t.integer  "validation_id"
    t.string   "rule_key"
    t.string   "operator"
    t.integer  "question_id"
    t.integer  "answer_id"
    t.datetime "datetime_value"
    t.integer  "integer_value"
    t.float    "float_value"
    t.string   "unit"
    t.text     "text_value"
    t.string   "string_value"
    t.string   "response_other"
    t.string   "regexp"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "validations", force: true do |t|
    t.integer  "answer_id"
    t.string   "rule"
    t.string   "message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
