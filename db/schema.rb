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

ActiveRecord::Schema.define(version: 20170727205200) do

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

  create_table "assignments", force: :cascade do |t|
    t.integer  "assigned_id"
    t.string   "assigned_type"
    t.integer  "user_id"
    t.integer  "assigned_by_id"
    t.integer  "status",         default: 1
    t.integer  "availability",   default: 0
    t.string   "title"
    t.text     "description"
    t.text     "notes"
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.datetime "due_at"
    t.hstore   "properties"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "assignments", ["assigned_by_id"], name: "index_assignments_on_assigned_by_id", using: :btree
  add_index "assignments", ["assigned_id", "assigned_type"], name: "index_assignments_on_assigned_id_and_assigned_type", using: :btree
  add_index "assignments", ["user_id"], name: "index_assignments_on_user_id", using: :btree

  create_table "bot_sessions", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.string   "expected_intents", default: [], array: true
    t.hstore   "context",          default: {}
    t.hstore   "properties",       default: {}
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "bot_sessions", ["provider", "uid", "user_id"], name: "index_bot_sessions_on_provider_and_uid_and_user_id", using: :btree
  add_index "bot_sessions", ["updated_at"], name: "index_bot_sessions_on_updated_at", using: :btree

  create_table "cart_items", force: :cascade do |t|
    t.integer  "cart_id"
    t.integer  "item_id"
    t.string   "item_type"
    t.integer  "quantity",   default: 1
    t.integer  "price",      default: 0
    t.integer  "subtotal",   default: 0
    t.hstore   "properties", default: {}
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "cart_items", ["cart_id"], name: "index_cart_items_on_cart_id", using: :btree
  add_index "cart_items", ["item_id", "item_type"], name: "index_cart_items_on_item_id_and_item_type", using: :btree

  create_table "carts", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "status",             default: 1
    t.integer  "subtotal",           default: 0
    t.integer  "estimated_tax",      default: 0
    t.integer  "estimated_shipping", default: 0
    t.integer  "estimated_total",    default: 0
    t.string   "ip"
    t.hstore   "properties",         default: {}
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "order_id"
  end

  add_index "carts", ["order_id"], name: "index_carts_on_order_id", using: :btree
  add_index "carts", ["user_id"], name: "index_carts_on_user_id", using: :btree

  create_table "categories", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "parent_id"
    t.string   "name"
    t.string   "type"
    t.integer  "lft"
    t.integer  "rgt"
    t.text     "description"
    t.text     "avatar"
    t.text     "cover_image"
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
    t.string   "code"
  end

  add_index "contacts", ["code"], name: "index_contacts_on_code", unique: true, using: :btree
  add_index "contacts", ["email", "type"], name: "index_contacts_on_email_and_type", using: :btree

  create_table "equipment", force: :cascade do |t|
    t.string   "title"
    t.string   "slug"
    t.integer  "parent_id"
    t.integer  "rgt"
    t.integer  "lft"
    t.text     "avatar"
    t.text     "aliases",     default: [], array: true
    t.text     "description"
    t.text     "content"
    t.string   "unit_type"
    t.integer  "unit"
    t.string   "tags",        default: [], array: true
    t.hstore   "properties",  default: {}
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "cover_image"
    t.integer  "status",      default: 0
  end

  add_index "equipment", ["parent_id"], name: "index_equipment_on_parent_id", using: :btree
  add_index "equipment", ["slug"], name: "index_equipment_on_slug", unique: true, using: :btree

  create_table "equipment_models", force: :cascade do |t|
    t.integer  "equipment_id"
    t.string   "title"
    t.string   "slug"
    t.string   "brand"
    t.text     "description"
    t.text     "content"
    t.text     "avatar"
    t.integer  "status",       default: 0
    t.hstore   "properties",   default: {}
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "equipment_models", ["equipment_id"], name: "index_equipment_models_on_equipment_id", using: :btree
  add_index "equipment_models", ["slug"], name: "index_equipment_models_on_slug", unique: true, using: :btree

  create_table "equipment_places", force: :cascade do |t|
    t.integer  "place_id"
    t.integer  "equipment_id"
    t.string   "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "equipment_places", ["equipment_id"], name: "index_equipment_places_on_equipment_id", using: :btree
  add_index "equipment_places", ["place_id"], name: "index_equipment_places_on_place_id", using: :btree

  create_table "foods", force: :cascade do |t|
    t.string   "title"
    t.string   "slug"
    t.string   "description"
    t.text     "content"
    t.text     "avatar"
    t.text     "nutrition"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "cover_image"
  end

  add_index "foods", ["slug"], name: "index_foods_on_slug", unique: true, using: :btree

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

  create_table "geo_addresses", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "geo_state_id"
    t.integer  "geo_country_id"
    t.integer  "status"
    t.string   "address_type"
    t.string   "title"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "street"
    t.string   "street2"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "phone"
    t.boolean  "preferred",      default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "geo_addresses", ["geo_country_id", "geo_state_id"], name: "index_geo_addresses_on_geo_country_id_and_geo_state_id", using: :btree
  add_index "geo_addresses", ["user_id"], name: "index_geo_addresses_on_user_id", using: :btree

  create_table "geo_countries", force: :cascade do |t|
    t.string   "name"
    t.string   "abbrev"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "geo_states", force: :cascade do |t|
    t.integer  "geo_country_id"
    t.string   "name"
    t.string   "abbrev"
    t.string   "country"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "geo_states", ["geo_country_id"], name: "index_geo_states_on_geo_country_id", using: :btree

  create_table "ingredients", force: :cascade do |t|
    t.integer  "recipe_id"
    t.integer  "food_id"
    t.string   "amount"
    t.string   "unit"
    t.string   "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ingredients", ["food_id"], name: "index_ingredients_on_food_id", using: :btree
  add_index "ingredients", ["recipe_id"], name: "index_ingredients_on_recipe_id", using: :btree

  create_table "lead_offer_optins", force: :cascade do |t|
    t.integer  "lead_offer_id"
    t.integer  "optin_id"
    t.integer  "status",        default: 1
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "lead_offer_optins", ["lead_offer_id", "optin_id"], name: "index_lead_offer_optins_on_lead_offer_id_and_optin_id", using: :btree

  create_table "lead_offers", force: :cascade do |t|
    t.integer  "place_id"
    t.string   "title"
    t.string   "slug"
    t.string   "avatar"
    t.string   "cover_image"
    t.text     "description"
    t.string   "item_name"
    t.string   "submit_label"
    t.text     "thank_you_msg"
    t.string   "email_subject"
    t.text     "email_msg"
    t.string   "download_url"
    t.integer  "status",        default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "lead_offers", ["place_id"], name: "index_lead_offers_on_place_id", using: :btree
  add_index "lead_offers", ["slug"], name: "index_lead_offers_on_slug", unique: true, using: :btree
  add_index "lead_offers", ["status"], name: "index_lead_offers_on_status", using: :btree

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
    t.text     "cover_image"
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
    t.string  "slug"
    t.text    "aliases",          default: [],         array: true
    t.string  "unit"
    t.integer "user_id"
    t.string  "metric_type"
    t.text    "description"
    t.string  "target_period",    default: "all_time"
    t.string  "target_type",      default: "value"
    t.float   "target_min"
    t.float   "target_max"
    t.integer "availability",     default: 0
    t.float   "target"
    t.string  "target_direction", default: "at_most"
  end

  add_index "metrics", ["movement_id"], name: "index_metrics_on_movement_id", using: :btree
  add_index "metrics", ["slug"], name: "index_metrics_on_slug", unique: true, using: :btree

  create_table "movement_relationships", force: :cascade do |t|
    t.integer  "movement_id"
    t.integer  "related_movement_id"
    t.string   "relation_type",       default: "variant"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "movement_relationships", ["movement_id"], name: "index_movement_relationships_on_movement_id", using: :btree
  add_index "movement_relationships", ["related_movement_id"], name: "index_movement_relationships_on_related_movement_id", using: :btree

  create_table "movements", force: :cascade do |t|
    t.integer  "equipment_id"
    t.integer  "movement_category_id"
    t.integer  "parent_id"
    t.integer  "rgt"
    t.integer  "lft"
    t.string   "title"
    t.string   "slug"
    t.text     "avatar"
    t.text     "aliases",              default: [],     array: true
    t.string   "description"
    t.text     "content"
    t.string   "measured_by",          default: "reps"
    t.string   "anatomy"
    t.integer  "status",               default: 1
    t.string   "tags",                 default: [],     array: true
    t.hstore   "properties",           default: {}
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "cover_image"
    t.string   "movement_type"
  end

  add_index "movements", ["equipment_id"], name: "index_movements_on_equipment_id", using: :btree
  add_index "movements", ["parent_id"], name: "index_movements_on_parent_id", using: :btree
  add_index "movements", ["slug"], name: "index_movements_on_slug", unique: true, using: :btree

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
    t.float    "sub_value"
    t.string   "unit"
    t.string   "sub_unit"
    t.string   "rx"
    t.text     "notes"
    t.datetime "started_at"
    t.datetime "ended_at"
    t.datetime "recorded_at"
    t.hstore   "properties",    default: {}
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "observations", ["parent_id"], name: "index_observations_on_parent_id", using: :btree
  add_index "observations", ["user_id", "tmp_id"], name: "index_observations_on_user_id_and_tmp_id", using: :btree

  create_table "order_items", force: :cascade do |t|
    t.integer  "order_id"
    t.integer  "item_id"
    t.string   "item_type"
    t.string   "title"
    t.integer  "quantity",        default: 1
    t.integer  "price",           default: 0
    t.integer  "subtotal",        default: 0
    t.string   "tax_code"
    t.integer  "order_item_type", default: 1
    t.hstore   "properties",      default: {}
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "order_items", ["item_id", "item_type", "order_id"], name: "index_order_items_on_item_id_and_item_type_and_order_id", using: :btree
  add_index "order_items", ["order_item_type", "order_id"], name: "index_order_items_on_order_item_type_and_order_id", using: :btree

  create_table "orders", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "billing_address_id"
    t.integer  "shipping_address_id"
    t.string   "code"
    t.string   "email"
    t.integer  "status",              default: 0
    t.integer  "subtotal",            default: 0
    t.integer  "tax",                 default: 0
    t.integer  "shipping",            default: 0
    t.integer  "total"
    t.string   "currency",            default: "USD"
    t.text     "customer_notes"
    t.text     "support_notes"
    t.datetime "fulfilled_at"
    t.hstore   "properties",          default: {}
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "orders", ["code"], name: "index_orders_on_code", unique: true, using: :btree
  add_index "orders", ["email", "billing_address_id", "shipping_address_id"], name: "email_addr_indx", using: :btree
  add_index "orders", ["email", "status"], name: "index_orders_on_email_and_status", using: :btree
  add_index "orders", ["user_id", "billing_address_id", "shipping_address_id"], name: "user_id_addr_indx", using: :btree

  create_table "places", force: :cascade do |t|
    t.string   "title"
    t.string   "slug"
    t.string   "description"
    t.text     "content"
    t.text     "avatar"
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
    t.text     "cover_image"
  end

  add_index "places", ["slug"], name: "index_places_on_slug", unique: true, using: :btree

  create_table "product_variants", force: :cascade do |t|
    t.integer  "product_id"
    t.string   "title"
    t.string   "slug"
    t.string   "avatar"
    t.string   "option_name",    default: "size"
    t.string   "option_value"
    t.text     "description"
    t.integer  "status",         default: 1
    t.integer  "seq",            default: 1
    t.integer  "price",          default: 0
    t.integer  "shipping_price", default: 0
    t.integer  "inventory",      default: -1
    t.hstore   "properties",     default: {}
    t.datetime "publish_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "product_variants", ["option_name", "option_value"], name: "index_product_variants_on_option_name_and_option_value", using: :btree
  add_index "product_variants", ["product_id"], name: "index_product_variants_on_product_id", using: :btree
  add_index "product_variants", ["seq"], name: "index_product_variants_on_seq", using: :btree
  add_index "product_variants", ["slug"], name: "index_product_variants_on_slug", unique: true, using: :btree

  create_table "products", force: :cascade do |t|
    t.integer  "category_id"
    t.text     "shopify_code"
    t.string   "title"
    t.string   "caption"
    t.string   "slug"
    t.string   "avatar"
    t.integer  "status",          default: 0
    t.text     "description"
    t.text     "content"
    t.datetime "publish_at"
    t.integer  "price",           default: 0
    t.integer  "suggested_price", default: 0
    t.string   "currency",        default: "USD"
    t.string   "tags",            default: [],      array: true
    t.hstore   "properties",      default: {}
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "brand"
    t.string   "model"
    t.text     "size_info"
    t.text     "notes"
    t.integer  "collection_id"
    t.integer  "shipping_price",  default: 0
    t.string   "tax_code",        default: "00000"
    t.integer  "seq",             default: 1
  end

  add_index "products", ["category_id"], name: "index_products_on_category_id", using: :btree
  add_index "products", ["slug"], name: "index_products_on_slug", unique: true, using: :btree
  add_index "products", ["status"], name: "index_products_on_status", using: :btree
  add_index "products", ["tags"], name: "index_products_on_tags", using: :gin

  create_table "recipes", force: :cascade do |t|
    t.string   "title"
    t.string   "description"
    t.text     "content"
    t.text     "avatar"
    t.string   "slug"
    t.string   "prep_time"
    t.string   "cook_time"
    t.string   "serves"
    t.string   "nutrition"
    t.integer  "status",      default: 0
    t.datetime "publish_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "cover_image"
    t.integer  "category_id"
    t.string   "tags",        default: [], array: true
  end

  add_index "recipes", ["category_id"], name: "index_recipes_on_category_id", using: :btree
  add_index "recipes", ["slug"], name: "index_recipes_on_slug", unique: true, using: :btree
  add_index "recipes", ["tags"], name: "index_recipes_on_tags", using: :gin

  create_table "team_users", force: :cascade do |t|
    t.integer  "team_id"
    t.integer  "user_id"
    t.string   "slack_user_id"
    t.hstore   "properties",    default: {}
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "team_users", ["slack_user_id", "user_id"], name: "index_team_users_on_slack_user_id_and_user_id", using: :btree
  add_index "team_users", ["team_id"], name: "index_team_users_on_team_id", using: :btree
  add_index "team_users", ["user_id"], name: "index_team_users_on_user_id", using: :btree

  create_table "teams", force: :cascade do |t|
    t.string   "name"
    t.string   "slack_team_id"
    t.hstore   "properties",    default: {}
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "teams", ["name"], name: "index_teams_on_name", using: :btree
  add_index "teams", ["slack_team_id"], name: "index_teams_on_slack_team_id", using: :btree

  create_table "terms", force: :cascade do |t|
    t.string   "title"
    t.string   "slug"
    t.text     "content"
    t.text     "aliases",    default: [], array: true
    t.integer  "status",     default: 1
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "transactions", force: :cascade do |t|
    t.integer  "parent_obj_id"
    t.string   "parent_obj_type"
    t.integer  "transaction_type", default: 1
    t.string   "provider"
    t.string   "reference_code"
    t.integer  "amount",           default: 0
    t.string   "currency",         default: "USD"
    t.integer  "status",           default: 1
    t.hstore   "properties",       default: {}
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "transactions", ["parent_obj_id", "parent_obj_type"], name: "index_transactions_on_parent_obj_id_and_parent_obj_type", using: :btree
  add_index "transactions", ["reference_code"], name: "index_transactions_on_reference_code", using: :btree

  create_table "user_inputs", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "result_obj_id"
    t.string   "result_obj_type"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "source"
    t.string   "action",          default: "created"
    t.string   "result_status",   default: "success"
    t.text     "system_notes"
  end

  add_index "user_inputs", ["result_obj_id", "result_obj_type"], name: "index_user_inputs_on_result_obj_id_and_result_obj_type", using: :btree
  add_index "user_inputs", ["user_id"], name: "index_user_inputs_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email",                  default: "",                           null: false
    t.string   "encrypted_password",     default: "",                           null: false
    t.string   "slug"
    t.string   "first_name"
    t.string   "last_name"
    t.text     "avatar"
    t.text     "cover_image"
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
    t.text     "authorization_code"
    t.boolean  "use_metric_units",       default: false
  end

  add_index "users", ["authentication_token"], name: "index_users_on_authentication_token", unique: true, using: :btree
  add_index "users", ["authorization_code"], name: "index_users_on_authorization_code", using: :btree
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
    t.integer  "workout_segment_id"
    t.integer  "seq",                default: 1
  end

  add_index "workout_movements", ["equipment_id"], name: "index_workout_movements_on_equipment_id", using: :btree
  add_index "workout_movements", ["movement_id"], name: "index_workout_movements_on_movement_id", using: :btree
  add_index "workout_movements", ["workout_id"], name: "index_workout_movements_on_workout_id", using: :btree

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

  add_index "workout_segments", ["workout_id"], name: "index_workout_segments_on_workout_id", using: :btree

  create_table "workouts", force: :cascade do |t|
    t.string   "title"
    t.string   "slug"
    t.integer  "workout_category_id"
    t.string   "workout_type"
    t.text     "avatar"
    t.text     "cover_image"
    t.text     "description"
    t.text     "content"
    t.integer  "total_duration"
    t.integer  "total_reps"
    t.integer  "time_cap"
    t.integer  "status",              default: 0
    t.datetime "publish_at"
    t.string   "tags",                default: [], array: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.hstore   "properties",          default: {}
    t.text     "description_speech"
    t.text     "start_speech"
  end

  add_index "workouts", ["slug"], name: "index_workouts_on_slug", unique: true, using: :btree

end
