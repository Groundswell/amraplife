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

ActiveRecord::Schema.define(version: 20170215170912) do

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

  create_table "card_designs", force: :cascade do |t|
    t.string   "title"
    t.string   "slug"
    t.text     "avatar"
    t.text     "description"
    t.integer  "status",      default: 1
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "card_designs", ["slug"], name: "index_card_designs_on_slug", unique: true, using: :btree

  create_table "cards", force: :cascade do |t|
    t.integer  "card_design_id"
    t.string   "pub_id"
    t.string   "from_name"
    t.string   "from_email"
    t.string   "to_name"
    t.string   "to_email"
    t.text     "message"
    t.boolean  "viewed",         default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "cards", ["card_design_id"], name: "index_cards_on_card_design_id", using: :btree
  add_index "cards", ["pub_id"], name: "index_cards_on_pub_id", using: :btree
  add_index "cards", ["to_email"], name: "index_cards_on_to_email", using: :btree

  create_table "cart_items", force: :cascade do |t|
    t.integer  "item_id"
    t.string   "item_type"
    t.integer  "quantity",   default: 1
    t.hstore   "properties", default: {}
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "cart_items", ["item_id", "item_type"], name: "index_cart_items_on_item_id_and_item_type", using: :btree

  create_table "carts", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "status",     default: 1
    t.string   "ip"
    t.hstore   "properties", default: {}
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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
  end

  add_index "contacts", ["email", "type"], name: "index_contacts_on_email_and_type", using: :btree

  create_table "coupon_redemptions", force: :cascade do |t|
    t.integer  "coupon_id"
    t.integer  "order_id"
    t.integer  "user_id"
    t.string   "email"
    t.integer  "applied_discount"
    t.integer  "status",           default: 1
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "coupon_redemptions", ["coupon_id"], name: "index_coupon_redemptions_on_coupon_id", using: :btree
  add_index "coupon_redemptions", ["email"], name: "index_coupon_redemptions_on_email", using: :btree
  add_index "coupon_redemptions", ["order_id"], name: "index_coupon_redemptions_on_order_id", using: :btree
  add_index "coupon_redemptions", ["user_id"], name: "index_coupon_redemptions_on_user_id", using: :btree

  create_table "coupons", force: :cascade do |t|
    t.integer  "valid_for_item_id"
    t.string   "valid_for_email"
    t.string   "title"
    t.string   "code"
    t.text     "description"
    t.string   "discount_type"
    t.integer  "discount",          default: 0
    t.string   "discount_base",     default: "item"
    t.integer  "max_redemptions",   default: 1
    t.string   "duration_type",     default: "once"
    t.string   "duration_days",     default: "0"
    t.datetime "publish_at"
    t.datetime "expires_at"
    t.integer  "status",            default: 1
    t.hstore   "properties",        default: {}
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "coupons", ["code"], name: "index_coupons_on_code", using: :btree
  add_index "coupons", ["valid_for_email"], name: "index_coupons_on_valid_for_email", using: :btree

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
    t.text    "aliases",     default: [], array: true
    t.string  "unit"
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

  add_index "observations", ["parent_id"], name: "index_observations_on_parent_id", using: :btree
  add_index "observations", ["user_id", "tmp_id"], name: "index_observations_on_user_id_and_tmp_id", using: :btree

  create_table "order_items", force: :cascade do |t|
    t.integer  "order_id"
    t.integer  "item_id"
    t.string   "item_type"
    t.integer  "order_item_type", default: 1
    t.integer  "quantity",        default: 1
    t.integer  "amount",          default: 0
    t.string   "tax_code"
    t.string   "label"
    t.hstore   "properties",      default: {}
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "order_items", ["item_id", "item_type", "order_id"], name: "index_order_items_on_item_id_and_item_type_and_order_id", using: :btree
  add_index "order_items", ["order_item_type", "order_id"], name: "index_order_items_on_order_item_type_and_order_id", using: :btree

  create_table "orders", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "cart_id"
    t.integer  "billing_address_id"
    t.integer  "shipping_address_id"
    t.string   "code"
    t.string   "email"
    t.integer  "status",              default: 0
    t.integer  "total"
    t.string   "currency",            default: "USD"
    t.text     "customer_comment"
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

  create_table "plans", force: :cascade do |t|
    t.integer "product_id"
    t.string  "code"
    t.integer "price",                default: 0
    t.integer "renewal_price",        default: 0
    t.string  "currency",             default: "USD"
    t.string  "tax_code"
    t.hstore  "properties",           default: {}
    t.string  "name"
    t.string  "caption"
    t.text    "description"
    t.string  "statement_descriptor"
    t.string  "interval",             default: "month"
    t.integer "interval_count",       default: 1
    t.integer "trial_period_days",    default: 0
    t.integer "status",               default: 1
  end

  add_index "plans", ["code"], name: "index_plans_on_code", unique: true, using: :btree

  create_table "product_options", force: :cascade do |t|
    t.integer "product_id"
    t.string  "label"
    t.string  "code"
  end

  add_index "product_options", ["product_id", "label"], name: "index_product_options_on_product_id_and_label", using: :btree

  create_table "products", force: :cascade do |t|
    t.integer  "category_id"
    t.string   "title"
    t.string   "caption"
    t.string   "slug"
    t.text     "avatar"
    t.integer  "default_product_type", default: 1
    t.string   "fulfilled_by",         default: "self"
    t.integer  "status",               default: 0
    t.text     "description"
    t.text     "content"
    t.datetime "publish_at"
    t.datetime "preorder_at"
    t.datetime "release_at"
    t.integer  "suggested_price",      default: 0
    t.integer  "price",                default: 0
    t.string   "currency",             default: "USD"
    t.integer  "inventory",            default: -1
    t.string   "tags",                 default: [],     array: true
    t.string   "tax_code"
    t.hstore   "properties",           default: {}
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "cover_image"
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
  end

  add_index "recipes", ["slug"], name: "index_recipes_on_slug", unique: true, using: :btree

  create_table "shipment_items", force: :cascade do |t|
    t.integer  "shipment_id"
    t.integer  "order_item_id"
    t.integer  "quantity",      default: 1
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "shipment_items", ["shipment_id", "order_item_id"], name: "index_shipment_items_on_shipment_id_and_order_item_id", using: :btree

  create_table "shipments", force: :cascade do |t|
    t.integer  "order_id"
    t.string   "provider"
    t.string   "reference"
    t.integer  "amount",     default: 0
    t.integer  "status",     default: 0
    t.hstore   "properties", default: {}
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "shipments", ["order_id"], name: "index_shipments_on_order_id", using: :btree

  create_table "sku_options", force: :cascade do |t|
    t.integer "sku_id"
    t.string  "code"
    t.string  "value"
  end

  add_index "sku_options", ["sku_id", "code", "value"], name: "index_sku_options_on_sku_id_and_code_and_value", using: :btree

  create_table "skus", force: :cascade do |t|
    t.integer  "product_id"
    t.string   "name"
    t.string   "label"
    t.string   "code"
    t.text     "avatar"
    t.integer  "status",      default: 0
    t.string   "tax_code"
    t.integer  "price",       default: 0
    t.integer  "inventory",   default: -1
    t.string   "currency",    default: "USD"
    t.hstore   "properties",  default: {}
    t.hstore   "options",     default: {}
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "cover_image"
  end

  add_index "skus", ["code"], name: "index_skus_on_code", unique: true, using: :btree

  create_table "subscriptions", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "status",               default: 1
    t.hstore   "properties",           default: {}
    t.integer  "plan_id"
    t.integer  "quantity",             default: 1
    t.boolean  "cancel_at_period_end"
    t.datetime "canceled_at"
    t.datetime "current_period_end"
    t.datetime "current_period_start"
    t.datetime "ended_at"
    t.datetime "start_at"
    t.datetime "trial_end_at"
    t.datetime "trail_start_at"
    t.integer  "amount",               default: 0
    t.string   "currency",             default: "USD"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "subscriptions", ["plan_id"], name: "index_subscriptions_on_plan_id", using: :btree
  add_index "subscriptions", ["user_id"], name: "index_subscriptions_on_user_id", using: :btree

  create_table "tax_rates", force: :cascade do |t|
    t.integer  "geo_state_id"
    t.float    "rate",         default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tax_rates", ["geo_state_id"], name: "index_tax_rates_on_geo_state_id", using: :btree

  create_table "transactions", force: :cascade do |t|
    t.integer  "parent_id"
    t.string   "parent_type"
    t.integer  "transaction_type"
    t.string   "provider"
    t.string   "reference"
    t.string   "message"
    t.integer  "amount",           default: 0
    t.string   "currency",         default: "USD"
    t.integer  "status",           default: 1
    t.hstore   "properties",       default: {}
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "transactions", ["parent_id", "parent_type"], name: "index_transactions_on_parent_id_and_parent_type", using: :btree
  add_index "transactions", ["reference"], name: "index_transactions_on_reference", using: :btree
  add_index "transactions", ["status", "reference"], name: "index_transactions_on_status_and_reference", using: :btree
  add_index "transactions", ["transaction_type"], name: "index_transactions_on_transaction_type", using: :btree

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
  end

  add_index "workouts", ["slug"], name: "index_workouts_on_slug", unique: true, using: :btree

end
