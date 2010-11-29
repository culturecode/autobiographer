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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20101124041314) do

  create_table "authentications", :force => true do |t|
    t.integer  "user_id"
    t.string   "type"
    t.text     "identifier"
    t.text     "token"
    t.text     "secret"
    t.datetime "last_sync"
  end

  add_index "authentications", ["identifier"], :name => "index_authentications_on_identifier"
  add_index "authentications", ["user_id"], :name => "index_authentications_on_user_id"

  create_table "chapters", :force => true do |t|
    t.string "title"
    t.text   "subtitle"
  end

  create_table "checkins", :force => true do |t|
    t.text     "place"
    t.text     "comment"
    t.text     "identifier"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", :force => true do |t|
    t.text     "text"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "identifier"
  end

  create_table "events", :force => true do |t|
    t.datetime "timestamp"
    t.integer  "offset",            :default => 0, :null => false
    t.integer  "details_id"
    t.string   "details_type"
    t.integer  "user_id"
    t.integer  "authentication_id"
  end

  add_index "events", ["authentication_id"], :name => "index_events_on_authentication_id"
  add_index "events", ["details_id", "details_type"], :name => "index_events_on_details_id_and_details_type"
  add_index "events", ["timestamp"], :name => "index_events_on_timestamp"
  add_index "events", ["user_id"], :name => "index_events_on_user_id"

  create_table "notes", :force => true do |t|
    t.text "text"
  end

  create_table "photo_groups", :force => true do |t|
    t.text     "identifier"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "photos", :force => true do |t|
    t.string   "file"
    t.integer  "photo_group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
