# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_02_19_141033) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "feature_overrides", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "feature_id", null: false
    t.string "override_id", null: false
    t.string "override_type", null: false
    t.boolean "state", null: false
    t.datetime "updated_at", null: false
    t.index ["feature_id", "override_type", "override_id"], name: "index_feature_overrides_uniqueness", unique: true
    t.index ["feature_id"], name: "index_feature_overrides_on_feature_id"
  end

  create_table "features", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.boolean "default_state", null: false
    t.text "description"
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_features_on_name", unique: true
  end

  create_table "groups", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email"
    t.bigint "group_id", null: false
    t.string "name"
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_users_on_group_id"
  end

  add_foreign_key "feature_overrides", "features"
  add_foreign_key "users", "groups"
end
