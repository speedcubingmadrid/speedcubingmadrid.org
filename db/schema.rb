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

ActiveRecord::Schema.define(version: 20180417084530) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "posts", force: :cascade do |t|
    t.string "title", default: "", null: false
    t.text "body"
    t.string "slug", null: false
    t.boolean "feature", default: false, null: false
    t.bigint "user_id", null: false
    t.boolean "draft", default: true, null: false
    t.boolean "competition_page", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_posts_on_slug"
    t.index ["user_id"], name: "index_posts_on_user_id"
  end

  create_table "subscriptions", force: :cascade do |t|
    t.bigint "user_id"
    t.string "name"
    t.string "firstname"
    t.string "wca_id"
    t.string "email"
    t.datetime "payed_at"
    t.string "receipt_url"
    t.index ["user_id"], name: "index_subscriptions_on_user_id"
    t.index ["wca_id"], name: "index_subscriptions_on_wca_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "wca_id"
    t.string "country_iso2"
    t.string "email"
    t.string "avatar_url"
    t.string "avatar_thumb_url"
    t.string "gender"
    t.date "birthdate"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "delegate_status"
    t.boolean "admin", default: false
    t.boolean "communication", default: false
    t.boolean "french_delegate", default: false
  end

end
