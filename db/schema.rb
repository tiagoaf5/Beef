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

ActiveRecord::Schema.define(version: 20141202163606) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bet_score_notifications", force: true do |t|
    t.datetime "added_at"
    t.boolean  "read"
    t.integer  "user_id"
    t.integer  "bet_id"
  end

  add_index "bet_score_notifications", ["bet_id", "user_id"], name: "index_bet_notif_unique", unique: true, using: :btree
  add_index "bet_score_notifications", ["user_id"], name: "index_bet_score_notifications_on_user_id", using: :btree

  create_table "bets", force: true do |t|
    t.integer  "team1_goals"
    t.integer  "team2_goals"
    t.integer  "score",       default: 0
    t.integer  "user_id"
    t.integer  "game_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "league_id"
  end

  add_index "bets", ["game_id"], name: "index_bets_on_game_id", using: :btree
  add_index "bets", ["user_id"], name: "index_bets_on_user_id", using: :btree

  create_table "championships", force: true do |t|
    t.integer  "year"
    t.string   "name"
    t.string   "country"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "games", force: true do |t|
    t.string   "team1_name"
    t.string   "team2_name"
    t.integer  "team1_goals"
    t.integer  "team2_goals"
    t.datetime "time"
    t.integer  "championship_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "matchday"
  end

  add_index "games", ["championship_id"], name: "index_games_on_championship_id", using: :btree
  add_index "games", ["team1_name", "team2_name", "time"], name: "index_games_on_team1_name_and_team2_name_and_time", using: :btree

  create_table "invites_notifications", force: true do |t|
    t.datetime "added_at"
    t.boolean  "read"
    t.integer  "user_id"
    t.integer  "league_id"
  end

  add_index "invites_notifications", ["league_id", "user_id"], name: "index_invites_notif_unique", unique: true, using: :btree
  add_index "invites_notifications", ["league_id"], name: "index_invites_notifications_on_league_id", using: :btree
  add_index "invites_notifications", ["user_id"], name: "index_invites_notifications_on_user_id", using: :btree

  create_table "league_championships", force: true do |t|
    t.integer  "league_id"
    t.integer  "championship_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "league_championships", ["championship_id"], name: "index_league_championships_on_championship_id", using: :btree
  add_index "league_championships", ["league_id"], name: "index_league_championships_on_league_id", using: :btree

  create_table "league_users", force: true do |t|
    t.integer  "user_id"
    t.integer  "league_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_score", default: 0
  end

  add_index "league_users", ["league_id"], name: "index_league_users_on_league_id", using: :btree
  add_index "league_users", ["user_id"], name: "index_league_users_on_user_id", using: :btree

  create_table "leagues", force: true do |t|
    t.string   "name"
    t.integer  "score_correct"
    t.integer  "score_difference"
    t.integer  "score_prediction"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "owner_id"
  end

  create_table "pending_games_notifications", force: true do |t|
    t.datetime "added_at"
    t.boolean  "read"
    t.integer  "user_id"
    t.integer  "league_id"
    t.integer  "game_id"
  end

  add_index "pending_games_notifications", ["game_id", "league_id", "user_id"], name: "index_games_not_unique", unique: true, using: :btree
  add_index "pending_games_notifications", ["user_id"], name: "index_pending_games_notifications_on_user_id", using: :btree

  create_table "pending_users", force: true do |t|
    t.datetime "added_at"
    t.boolean  "read"
    t.text     "email"
    t.integer  "leagues_id"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.string   "image"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
