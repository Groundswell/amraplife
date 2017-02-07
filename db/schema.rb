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

ActiveRecord::Schema.define(version: 20161204184311) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"
  enable_extension "uuid-ossp"

  create_table "assets", force: :cascade do |t|
    t.integer  "parent_obj_id"
    t.string   "parent_obj_type"
    t.integer  "user_id"
    t.string   "title"
    t.string   "description"
    t.text     "content"
    t.string   "type"
    t.string   "sub_type"
    t.string   "use"
    t.string   "asset_type",        default: "image"
    t.string   "origin_name"
    t.string   "origin_identifier"
    t.text     "origin_url"
    t.text     "upload"
    t.integer  "height"
    t.integer  "width"
    t.integer  "duration"
    t.integer  "status",            default: 1
    t.integer  "availability",      default: 1
    t.string   "tags",              default: [],      array: true
    t.hstore   "properties",        default: {}
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "assets", ["parent_obj_id", "parent_obj_type", "asset_type", "use"], name: "swell_media_asset_use_index", using: :btree
  add_index "assets", ["parent_obj_type", "parent_obj_id"], name: "index_assets_on_parent_obj_type_and_parent_obj_id", using: :btree
  add_index "assets", ["tags"], name: "index_assets_on_tags", using: :gin

  create_table "categories", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "parent_id"
    t.string   "name"
    t.string   "type"
    t.integer  "lft"
    t.integer  "rgt"
    t.text     "description"
    t.string   "avatar"
    t.string   "cover_image"
    t.integer  "status",       default: 1
    t.integer  "availability", default: 1
    t.integer  "seq"
    t.string   "slug"
    t.hstore   "properties",   default: {}
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "categories", ["lft"], name: "index_categories_on_lft", using: :btree
  add_index "categories", ["parent_id"], name: "index_categories_on_parent_id", using: :btree
  add_index "categories", ["rgt"], name: "index_categories_on_rgt", using: :btree
  add_index "categories", ["slug"], name: "index_categories_on_slug", unique: true, using: :btree
  add_index "categories", ["type"], name: "index_categories_on_type", using: :btree
  add_index "categories", ["user_id"], name: "index_categories_on_user_id", using: :btree

  create_table "contacts", force: :cascade do |t|
    t.string   "email"
    t.string   "name"
    t.string   "subject"
    t.text     "message"
    t.string   "type"
    t.string   "ip"
    t.string   "sub_type"
    t.string   "http_referrer"
    t.integer  "status",        default: 1
    t.hstore   "properties",    default: {}
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "contacts", ["email", "type"], name: "index_contacts_on_email_and_type", using: :btree

  create_table "equipment", force: :cascade do |t|
    t.integer  "parent_id"
    t.integer  "rgt"
    t.integer  "lft"
    t.string   "slug"
    t.string   "title"
    t.text     "aliases",     default: [], array: true
    t.text     "description"
    t.text     "content"
    t.string   "unit_type"
    t.integer  "unit"
    t.hstore   "properties",  default: {}
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

  create_table "media", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "managed_by_id"
    t.string   "public_id"
    t.integer  "category_id"
    t.integer  "avatar_asset_id"
    t.integer  "working_media_version_id"
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.string   "type"
    t.string   "sub_type"
    t.string   "title"
    t.string   "subtitle"
    t.text     "avatar"
    t.string   "cover_path"
    t.string   "avatar_caption"
    t.string   "layout"
    t.string   "template"
    t.text     "description"
    t.text     "content"
    t.string   "slug"
    t.string   "redirect_url"
    t.boolean  "is_commentable",           default: true
    t.boolean  "is_sticky",                default: false
    t.boolean  "show_title",               default: true
    t.datetime "modified_at"
    t.text     "keywords",                 default: [],    array: true
    t.string   "duration"
    t.integer  "cached_char_count",        default: 0
    t.integer  "cached_word_count",        default: 0
    t.integer  "status",                   default: 1
    t.integer  "availability",             default: 1
    t.datetime "publish_at"
    t.hstore   "properties",               default: {}
    t.string   "tags",                     default: [],    array: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "media", ["category_id"], name: "index_media_on_category_id", using: :btree
  add_index "media", ["managed_by_id"], name: "index_media_on_managed_by_id", using: :btree
  add_index "media", ["public_id"], name: "index_media_on_public_id", using: :btree
  add_index "media", ["slug", "type"], name: "index_media_on_slug_and_type", using: :btree
  add_index "media", ["slug"], name: "index_media_on_slug", unique: true, using: :btree
  add_index "media", ["status", "availability"], name: "index_media_on_status_and_availability", using: :btree
  add_index "media", ["tags"], name: "index_media_on_tags", using: :gin
  add_index "media", ["user_id"], name: "index_media_on_user_id", using: :btree

  create_table "media_versions", force: :cascade do |t|
    t.integer  "media_id"
    t.integer  "user_id"
    t.integer  "status",               default: 1
    t.json     "versioned_attributes", default: {}
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "media_versions", ["media_id", "id"], name: "index_media_versions_on_media_id_and_id", using: :btree
  add_index "media_versions", ["media_id", "status", "id"], name: "index_media_versions_on_media_id_and_status_and_id", using: :btree

  create_table "metrics", force: :cascade do |t|
    t.integer "movement_id"
    t.string  "title"
    t.text    "aliases",     default: [], array: true
    t.string  "unit"
  end

  create_table "movements", force: :cascade do |t|
    t.integer  "equipment_id"
    t.integer  "movement_category_id"
    t.integer  "parent_id"
    t.integer  "rgt"
    t.integer  "lft"
    t.string   "title"
    t.string   "slug"
    t.string   "avatar"
    t.text     "aliases",              default: [],     array: true
    t.string   "description"
    t.text     "content"
    t.string   "measured_by",          default: "reps"
    t.string   "anatomy"
    t.string   "tags",                 default: [],     array: true
    t.hstore   "properties",           default: {}
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "oauth_credentials", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "name"
    t.string   "provider"
    t.string   "uid"
    t.string   "token"
    t.string   "refresh_token"
    t.string   "secret"
    t.datetime "expires_at"
    t.integer  "status",        default: 1
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "oauth_credentials", ["provider"], name: "index_oauth_credentials_on_provider", using: :btree
  add_index "oauth_credentials", ["secret"], name: "index_oauth_credentials_on_secret", using: :btree
  add_index "oauth_credentials", ["token"], name: "index_oauth_credentials_on_token", using: :btree
  add_index "oauth_credentials", ["uid"], name: "index_oauth_credentials_on_uid", using: :btree
  add_index "oauth_credentials", ["user_id"], name: "index_oauth_credentials_on_user_id", using: :btree

  create_table "observations", force: :cascade do |t|
    t.string   "tmp_id"
    t.integer  "user_id"
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.integer  "observed_id"
    t.string   "observed_type"
    t.string   "title"
    t.string   "content"
    t.float    "value"
    t.float    "sub_value",     default: 0.0
    t.string   "unit",          default: "secs"
    t.string   "sub_unit",      default: "reps"
    t.string   "rx"
    t.text     "notes"
    t.datetime "started_at"
    t.datetime "ended_at"
    t.datetime "recorded_at"
    t.hstore   "properties",    default: {}
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "observations", ["user_id", "tmp_id"], name: "index_observations_on_user_id_and_tmp_id", using: :btree

  create_table "places", force: :cascade do |t|
    t.string   "title"
    t.string   "description"
    t.text     "content"
    t.string   "phone"
    t.string   "address1"
    t.string   "address2"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "lat"
    t.string   "lon"
    t.string   "hours"
    t.string   "cost"
    t.integer  "status",      default: 1
    t.string   "tags",        default: [], array: true
    t.hstore   "properties",  default: {}
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email",                  default: "",                           null: false
    t.string   "encrypted_password",     default: "",                           null: false
    t.string   "slug"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "avatar"
    t.string   "cover_image"
    t.datetime "dob"
    t.string   "gender"
    t.string   "location"
    t.string   "address1"
    t.string   "address2"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "phone"
    t.integer  "status",                 default: 1
    t.integer  "role",                   default: 1
    t.integer  "level",                  default: 1
    t.string   "website_url"
    t.text     "bio"
    t.string   "short_bio"
    t.text     "sig"
    t.string   "ip"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "timezone",               default: "Pacific Time (US & Canada)"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.string   "password_hint"
    t.string   "password_hint_response"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",        default: 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.string   "authentication_token"
    t.hstore   "properties",             default: {}
    t.hstore   "settings"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["authentication_token"], name: "index_users_on_authentication_token", unique: true, using: :btree
  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["name"], name: "index_users_on_name", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["slug"], name: "index_users_on_slug", unique: true, using: :btree
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree

  create_table "workout_movements", force: :cascade do |t|
    t.integer  "workout_id"
    t.integer  "movement_id"
    t.integer  "equipment_id"
    t.string   "m_rx"
    t.string   "f_rx"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "workout_segments", force: :cascade do |t|
    t.integer  "workout_id"
    t.integer  "seq",                default: 1
    t.string   "title"
    t.text     "description"
    t.text     "content"
    t.string   "segment_type",       default: "ft"
    t.string   "clock_dir",          default: "down"
    t.string   "to_record",          default: "time"
    t.integer  "duration"
    t.integer  "repeat_count",       default: 0
    t.integer  "repeat_interval",    default: 60
    t.integer  "amrap_rep_interval", default: 0
    t.integer  "total_reps",         default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "workouts", force: :cascade do |t|
    t.string   "title"
    t.string   "slug"
    t.string   "workout_type"
    t.string   "avatar"
    t.string   "cover_img"
    t.text     "description"
    t.text     "content"
    t.integer  "total_duration"
    t.integer  "total_reps"
    t.integer  "time_cap"
    t.integer  "status",         default: 1
    t.datetime "publish_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.hstore   "properties",     default: {}
  end

end
