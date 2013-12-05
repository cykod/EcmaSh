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

ActiveRecord::Schema.define(version: 20131122140313) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "commands", force: true do |t|
    t.integer  "user_id"
    t.string   "type"
    t.string   "argv",       array: true
    t.boolean  "successful"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "opts",       array: true
  end

  create_table "file_node_contents", force: true do |t|
    t.text     "content"
    t.integer  "file_node_id"
    t.string   "content_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "nodes", force: true do |t|
    t.string   "name"
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
    t.string   "file_type"
    t.text     "fullpath"
    t.integer  "parent_id"
    t.integer  "parent_ids",                              array: true
    t.string   "type"
    t.integer  "user_id"
    t.integer  "lock_level",        limit: 2, default: 1
    t.integer  "width",             limit: 2
    t.integer  "height",            limit: 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "nodes", ["fullpath"], name: "index_nodes_on_fullpath", using: :btree
  add_index "nodes", ["user_id"], name: "index_nodes_on_user_id", using: :btree

  create_table "user_keys", force: true do |t|
    t.integer  "user_id"
    t.datetime "valid_until"
    t.string   "token"
    t.inet     "ip"
    t.datetime "created_at"
  end

  create_table "users", force: true do |t|
    t.string   "username",        default: "", null: false
    t.string   "password_digest", default: "", null: false
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

end
