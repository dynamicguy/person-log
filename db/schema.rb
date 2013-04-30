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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121220091714) do

  create_table "authentications", :force => true do |t|
    t.integer "user_id"
    t.string "provider"
    t.string "uid"
    t.text "raw"
    t.text "credentials"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "companies", :force => true do |t|
    t.string "industry"
    t.string "name"
    t.text "description"
    t.string "location"
    t.string "size"
    t.string "ctype"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "educations", :force => true do |t|
    t.integer "user_id"
    t.string "school"
    t.string "etype"
    t.integer "year"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string "degree", :limit => 127
    t.string "field_of_study", :limit => 127
    t.date "start_date"
    t.date "end_date"
  end

  create_table "newsletters", :force => true do |t|
    t.string "subject"
    t.datetime "delivered_at"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "places", :force => true do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "positions", :force => true do |t|
    t.string "name"
    t.text "summary"
    t.date "start_date"
    t.boolean "is_current"
    t.integer "company_id", :limit => 8
    t.integer "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.date "end_date"
  end

  create_table "postal_addresses", :force => true do |t|
    t.string "name"
    t.string "description"
    t.string "email"
    t.string "url"
    t.string "faxNumber"
    t.string "telephone"
    t.string "country"
    t.string "locality"
    t.string "region"
    t.string "postalCode"
    t.string "postOfficeBoxNumber"
    t.string "street"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "queries", :force => true do |t|
    t.string "q"
    t.integer "user_id"
    t.string "ua"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string "ip"
  end

  create_table "queue_classic_jobs", :force => true do |t|
    t.string "q_name"
    t.string "method"
    t.text "args"
    t.datetime "locked_at"
  end

  add_index "queue_classic_jobs", ["q_name", "id"], :name => "idx_qc_on_name_only_unlocked"

  create_table "rails_admin_histories", :force => true do |t|
    t.text "message"
    t.string "username"
    t.integer "item"
    t.string "table"
    t.integer "month", :limit => 2
    t.integer "year", :limit => 8
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "rails_admin_histories", ["item", "table", "month", "year"], :name => "index_rails_admin_histories"

  create_table "roles", :force => true do |t|
    t.string "name"
    t.integer "resource_id"
    t.string "resource_type"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "roles", ["name", "resource_type", "resource_id"], :name => "index_roles_on_name_and_resource_type_and_resource_id"
  add_index "roles", ["name"], :name => "index_roles_on_name"

  create_table "sessions", :force => true do |t|
    t.string "session_id", :null => false
    t.text "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "taggings", :force => true do |t|
    t.integer "tag_id"
    t.integer "taggable_id"
    t.string "taggable_type"
    t.integer "tagger_id"
    t.string "tagger_type"
    t.string "context", :limit => 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "urls", :force => true do |t|
    t.string "title"
    t.string "value"
    t.integer "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string "email", :default => "", :null => false
    t.string "encrypted_password", :default => ""
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string "name"
    t.string "avatar"
    t.text "bio"
    t.string "gender", :limit => 50, :default => "male"
    t.string "phone"
    t.string "provider"
    t.string "uid"
    t.string "invitation_token", :limit => 60
    t.string "password_salt", :limit => 60
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer "invitation_limit"
    t.integer "invited_by_id"
    t.string "invited_by_type"
    t.boolean "published", :default => false
    t.boolean "featured", :default => false
    t.datetime "published_at"
    t.date "birthday"
    t.date "deathday"
    t.string "birthplace"
    t.string "country"
    t.decimal "lat", :precision => 8, :scale => 2, :default => 0.0
    t.decimal "lon", :precision => 8, :scale => 2, :default => 0.0
    t.string "address"
    t.string "marital_status", :default => "single"
    t.boolean "opt_in", :default => false
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["invitation_token"], :name => "index_users_on_invitation_token"
  add_index "users", ["invited_by_id"], :name => "index_users_on_invited_by_id"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "users_friends", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "friend_id"
  end

  create_table "users_roles", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], :name => "index_users_roles_on_user_id_and_role_id"

  create_table "versions", :force => true do |t|
    t.string "item_type", :null => false
    t.integer "item_id", :null => false
    t.string "event", :null => false
    t.string "whodunnit"
    t.text "object"
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], :name => "index_versions_on_item_type_and_item_id"

  create_table "visits", :force => true do |t|
    t.integer "user_id"
    t.string "ip"
    t.string "ua"
    t.datetime "created"
  end

end
