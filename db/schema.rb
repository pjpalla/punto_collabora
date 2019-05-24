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

ActiveRecord::Schema.define(version: 20190311121007) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "answers", primary_key: "aid", force: :cascade do |t|
    t.integer "qid"
    t.text    "answer"
    t.integer "uid"
    t.text    "note"
    t.integer "subid"
  end

  create_table "brand_name_drugs", force: :cascade do |t|
    t.text     "drug_name"
    t.text     "category"
    t.text     "dosage"
    t.text     "effect"
    t.text     "sex"
    t.text     "age_range"
    t.text     "elapsed_time"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "drugs", force: :cascade do |t|
    t.text     "drug_name"
    t.text     "category"
    t.text     "dosage"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "effect"
    t.string   "sex",          limit: 1
    t.string   "age_range"
    t.string   "elapsed_time"
  end

  create_table "indicator_descriptions", force: :cascade do |t|
    t.string "name"
    t.text   "description"
  end

  create_table "indicators", force: :cascade do |t|
    t.integer  "uid"
    t.text     "card"
    t.integer  "i1"
    t.integer  "i2"
    t.integer  "i3"
    t.integer  "i4"
    t.integer  "i5"
    t.integer  "i6"
    t.integer  "i7"
    t.integer  "i8"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "i9"
    t.integer  "i10"
    t.integer  "i11"
  end

  create_table "members", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "members", ["email"], name: "index_members_on_email", unique: true, using: :btree
  add_index "members", ["reset_password_token"], name: "index_members_on_reset_password_token", unique: true, using: :btree

  create_table "patients", force: :cascade do |t|
    t.string   "patient_id"
    t.string   "collection_point"
    t.string   "collection_point_name"
    t.string   "collection_point_address"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "profiles", force: :cascade do |t|
    t.integer  "patient_id"
    t.integer  "member_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "job_title"
    t.string   "phone_number"
    t.string   "contact_email"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "profiles", ["patient_id"], name: "index_profiles_on_patient_id", using: :btree

  create_table "question_options", id: false, force: :cascade do |t|
    t.text    "odescription"
    t.integer "qid",                                                                    null: false
    t.integer "subid",                                                                  null: false
    t.integer "oid",          default: "nextval('question_options_oid_seq'::regclass)", null: false
  end

  create_table "questionnaires", primary_key: "quid", force: :cascade do |t|
    t.text "description"
  end

  create_table "questions", id: false, force: :cascade do |t|
    t.integer "qid",   null: false
    t.text    "qtext"
    t.integer "quid",  null: false
    t.integer "subid", null: false
  end

  create_table "surveys", force: :cascade do |t|
    t.integer  "uid"
    t.string   "card"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", primary_key: "uid", force: :cascade do |t|
    t.text   "collection_point"
    t.text   "age"
    t.string "sex",              limit: 1
    t.text   "card"
    t.text   "stratum"
    t.string "place"
  end

  add_foreign_key "answers", "questions", column: "qid", primary_key: "qid", name: "answers_quest_fk"
  add_foreign_key "answers", "users", column: "uid", primary_key: "uid", name: "answers_fk"
  add_foreign_key "question_options", "questions", column: "qid", primary_key: "qid", name: "question_options_fk"
  add_foreign_key "questions", "questionnaires", column: "quid", primary_key: "quid", name: "questions_fk"
end
