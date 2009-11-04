# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20091028142231) do

  create_table "avatars", :force => true do |t|
    t.integer  "obj_id"
    t.integer  "parent_id"
    t.string   "content_type"
    t.string   "filename"
    t.string   "thumbnail"
    t.integer  "size"
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "obj_type"
  end

  create_table "people", :force => true do |t|
    t.string   "name"
    t.string   "first_name"
    t.string   "email"
    t.string   "mobile"
    t.text     "description"
    t.date     "date_of_birth"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "team_id"
  end

  create_table "person_roles", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "players", :force => true do |t|
    t.string   "name"
    t.string   "first_name"
    t.integer  "current_number"
    t.integer  "position_id"
    t.text     "description"
    t.date     "date_of_birth"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "team_id"
  end

  create_table "positions", :force => true do |t|
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "scheduling_algorithm_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "tournament_type_id"
  end

  create_table "teams", :force => true do |t|
    t.string   "name"
    t.integer  "trainer_id"
    t.integer  "manager_id"
    t.integer  "captain_id"
    t.text     "description"
    t.string   "city"
    t.integer  "year_founded"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tournament_metadata", :force => true do |t|
    t.integer  "tournament_id"
    t.integer  "teams_count"
    t.integer  "games_count"
    t.integer  "default_game_duration"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tournament_teams", :force => true do |t|
    t.integer  "tournament_id"
    t.integer  "team_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tournament_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tournaments", :force => true do |t|
    t.string   "name"
    t.date     "start_date"
    t.date     "end_date"
    t.text     "description"
    t.string   "organizer"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "tournament_type_id"
    t.integer  "game_duration"
    t.integer  "switch_duration"
  end

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "email"
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.string   "name"
    t.boolean  "is_admin",                                :default => false, :null => false
    t.boolean  "show_page_info",                          :default => true,  :null => false
  end

end
