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

ActiveRecord::Schema[8.1].define(version: 2026_09_30_023000) do
  create_table "conversations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "game_master_notes", force: :cascade do |t|
    t.string "content"
    t.datetime "created_at", null: false
    t.boolean "is_public"
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "game_master_profiles", force: :cascade do |t|
    t.text "bio"
    t.datetime "created_at", null: false
    t.boolean "is_user_public", default: false, null: false
    t.datetime "last_used_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.string "name"
    t.string "profile_picture"
    t.json "systems", default: [], null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_game_master_profiles_on_user_id"
  end

  create_table "games", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.integer "game_master_profile_id", null: false
    t.boolean "is_session_zero_complete", default: false
    t.string "name"
    t.string "system", default: "Dungeons and Dragons 5e"
    t.datetime "updated_at", null: false
    t.index ["game_master_profile_id"], name: "index_games_on_game_master_profile_id"
  end

  create_table "lines", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.integer "game_id", null: false
    t.boolean "is_anonymous"
    t.integer "player_profile_id", null: false
    t.string "title"
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_lines_on_game_id"
    t.index ["player_profile_id"], name: "index_lines_on_player_profile_id"
  end

  create_table "messages", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "player_notes", force: :cascade do |t|
    t.string "content"
    t.datetime "created_at", null: false
    t.boolean "is_public"
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "player_profiles", force: :cascade do |t|
    t.text "character_description"
    t.string "character_image"
    t.string "character_name"
    t.string "character_sheet_link"
    t.datetime "created_at", null: false
    t.integer "game_id", null: false
    t.boolean "is_accepted", default: false
    t.boolean "is_user_public", default: false, null: false
    t.datetime "last_used_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["game_id"], name: "index_player_profiles_on_game_id"
    t.index ["user_id"], name: "index_player_profiles_on_user_id"
  end

  create_table "user_identities", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "provider", null: false
    t.string "uid", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["provider", "uid"], name: "index_user_identities_on_provider_and_uid", unique: true
    t.index ["user_id"], name: "index_user_identities_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email"
    t.string "encrypted_password", default: "", null: false
    t.string "name"
    t.string "profile_picture"
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "veils", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.integer "game_id", null: false
    t.boolean "is_anonymous"
    t.integer "player_profile_id", null: false
    t.string "title"
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_veils_on_game_id"
    t.index ["player_profile_id"], name: "index_veils_on_player_profile_id"
  end

  add_foreign_key "game_master_profiles", "users"
  add_foreign_key "games", "game_master_profiles"
  add_foreign_key "lines", "games"
  add_foreign_key "lines", "player_profiles"
  add_foreign_key "player_profiles", "games"
  add_foreign_key "player_profiles", "users"
  add_foreign_key "user_identities", "users"
  add_foreign_key "veils", "games"
  add_foreign_key "veils", "player_profiles"
end
