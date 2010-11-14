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

ActiveRecord::Schema.define(:version => 20101114021849) do

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
    t.integer  "user_id"
    t.string   "title"
    t.text     "subtitle"
    t.datetime "timestamp"
  end

  add_index "chapters", ["timestamp"], :name => "index_chapters_on_timestamp"

  create_table "events", :force => true do |t|
    t.datetime "timestamp"
    t.text     "place"
    t.text     "comment"
    t.integer  "authentication_id"
    t.text     "identifier"
  end

  add_index "events", ["authentication_id"], :name => "index_events_on_authentication_id"
  add_index "events", ["place"], :name => "index_events_on_place"
  add_index "events", ["timestamp"], :name => "index_events_on_timestamp"

  create_table "users", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
