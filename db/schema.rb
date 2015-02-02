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

ActiveRecord::Schema.define(version: 20150202182501) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "answers", force: true do |t|
    t.integer  "question_id"
    t.text     "answer"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.decimal  "rating"
  end

  add_index "answers", ["question_id"], name: "index_answers_on_question_id", using: :btree
  add_index "answers", ["user_id"], name: "index_answers_on_user_id", using: :btree

  create_table "attachments", force: true do |t|
    t.integer  "attachmentable_id"
    t.string   "file"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "attachmentable_type"
  end

  add_index "attachments", ["attachmentable_type", "attachmentable_id"], name: "index_attachments_on_attachmentable_type_and_attachmentable_id", using: :btree

  create_table "identities", force: true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "identities", ["provider", "uid"], name: "index_identities_on_provider_and_uid", unique: true, using: :btree
  add_index "identities", ["user_id"], name: "index_identities_on_user_id", using: :btree

  create_table "oauth_access_grants", force: true do |t|
    t.integer  "resource_owner_id", null: false
    t.integer  "application_id",    null: false
    t.string   "token",             null: false
    t.integer  "expires_in",        null: false
    t.text     "redirect_uri",      null: false
    t.datetime "created_at",        null: false
    t.datetime "revoked_at"
    t.string   "scopes"
  end

  add_index "oauth_access_grants", ["token"], name: "index_oauth_access_grants_on_token", unique: true, using: :btree

  create_table "oauth_access_tokens", force: true do |t|
    t.integer  "resource_owner_id"
    t.integer  "application_id"
    t.string   "token",             null: false
    t.string   "refresh_token"
    t.integer  "expires_in"
    t.datetime "revoked_at"
    t.datetime "created_at",        null: false
    t.string   "scopes"
  end

  add_index "oauth_access_tokens", ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true, using: :btree
  add_index "oauth_access_tokens", ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id", using: :btree
  add_index "oauth_access_tokens", ["token"], name: "index_oauth_access_tokens_on_token", unique: true, using: :btree

  create_table "oauth_applications", force: true do |t|
    t.string   "name",                      null: false
    t.string   "uid",                       null: false
    t.string   "secret",                    null: false
    t.text     "redirect_uri",              null: false
    t.string   "scopes",       default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "oauth_applications", ["uid"], name: "index_oauth_applications_on_uid", unique: true, using: :btree

  create_table "questions", force: true do |t|
    t.text     "question"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
    t.integer  "user_id"
    t.integer  "best_answer_id"
    t.decimal  "rating"
  end

  add_index "questions", ["best_answer_id"], name: "index_questions_on_best_answer_id", using: :btree
  add_index "questions", ["created_at"], name: "index_questions_on_created_at", using: :btree
  add_index "questions", ["user_id"], name: "index_questions_on_user_id", using: :btree

  create_table "questions_tags", force: true do |t|
    t.integer "question_id"
    t.integer "tag_id"
  end

  add_index "questions_tags", ["question_id", "tag_id"], name: "index_questions_tags_on_question_id_and_tag_id", unique: true, using: :btree
  add_index "questions_tags", ["tag_id"], name: "index_questions_tags_on_tag_id", using: :btree

  create_table "questions_users", force: true do |t|
    t.integer "question_id"
    t.integer "user_id"
  end

  add_index "questions_users", ["question_id"], name: "index_questions_users_on_question_id", using: :btree
  add_index "questions_users", ["user_id"], name: "index_questions_users_on_user_id", using: :btree

  create_table "ratings", force: true do |t|
    t.string   "ratingable_type"
    t.integer  "ratingable_id"
    t.integer  "user_id"
    t.decimal  "rating"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ratings", ["ratingable_type", "ratingable_id", "user_id"], name: "index_ratings_on_ratingable_type_and_ratingable_id_and_user_id", unique: true, using: :btree
  add_index "ratings", ["user_id"], name: "index_ratings_on_user_id", using: :btree

  create_table "remarks", force: true do |t|
    t.integer  "user_id"
    t.integer  "remarkable_id"
    t.text     "remark"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remarkable_type"
  end

  add_index "remarks", ["remarkable_type", "remarkable_id"], name: "index_remarks_on_remarkable_type_and_remarkable_id", using: :btree
  add_index "remarks", ["user_id"], name: "index_remarks_on_user_id", using: :btree

  create_table "tags", force: true do |t|
    t.string   "name"
    t.integer  "color_index"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "user_confirmation_requests", force: true do |t|
    t.string   "provider"
    t.string   "uid"
    t.string   "email"
    t.string   "username"
    t.string   "confirmation_token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "request_session_created_at"
  end

  add_index "user_confirmation_requests", ["provider", "uid"], name: "index_user_confirmation_requests_on_provider_and_uid", unique: true, using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "username"
    t.boolean  "admin",                  default: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

end
