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

ActiveRecord::Schema.define(version: 20140125020702) do

  create_table "api_uses", force: true do |t|
    t.integer  "user_id"
    t.date     "day"
    t.integer  "calls"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "api_uses", ["user_id"], name: "index_api_uses_on_user_id"

  create_table "categories", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cities", force: true do |t|
    t.string   "name"
    t.integer  "province_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "cities", ["province_id"], name: "index_cities_on_province_id"

  create_table "countries", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "data_collection_categories", force: true do |t|
    t.integer  "data_collection_id"
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "data_collection_categories", ["category_id"], name: "index_data_collection_categories_on_category_id"
  add_index "data_collection_categories", ["data_collection_id"], name: "index_data_collection_categories_on_data_collection_id"

  create_table "data_collections", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "institution"
    t.integer  "country_id"
    t.integer  "province_id"
    t.integer  "city_id"
    t.string   "collection_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "data_collections", ["city_id"], name: "index_data_collections_on_city_id"
  add_index "data_collections", ["country_id"], name: "index_data_collections_on_country_id"
  add_index "data_collections", ["province_id"], name: "index_data_collections_on_province_id"

  create_table "data_fields", force: true do |t|
    t.string   "name"
    t.boolean  "is_filter"
    t.integer  "data_collection_id"
    t.integer  "data_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_key"
  end

  add_index "data_fields", ["data_collection_id"], name: "index_data_fields_on_data_collection_id"
  add_index "data_fields", ["data_type_id"], name: "index_data_fields_on_data_type_id"

  create_table "data_types", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "provinces", force: true do |t|
    t.string   "name"
    t.integer  "country_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "provinces", ["country_id"], name: "index_provinces_on_country_id"

  create_table "roles", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "trackings", force: true do |t|
    t.datetime "date"
    t.string   "referal"
    t.string   "url"
    t.string   "format"
    t.string   "user_agent"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "session"
  end

  create_table "user_roles", force: true do |t|
    t.integer  "user_id"
    t.integer  "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_roles", ["role_id"], name: "index_user_roles_on_role_id"
  add_index "user_roles", ["user_id"], name: "index_user_roles_on_user_id"

  create_table "user_statuses", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email"
    t.string   "password"
    t.string   "salt"
    t.string   "apikey"
    t.integer  "user_status_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["user_status_id"], name: "index_users_on_user_status_id"

end
