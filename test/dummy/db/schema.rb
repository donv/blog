# frozen_string_literal: true

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

ActiveRecord::Schema.define(version: 5) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'

  create_table 'blog_entries', force: :cascade do |t|
    t.datetime 'datetime',                        null: false
    t.string   'title', limit: 64, null: false
    t.text     'text', null: false
    t.integer  'blog_id', default: 1, null: false
  end

  create_table 'blogs', force: :cascade do |t|
    t.string 'title', limit: 64, null: false
  end

  create_table 'images', force: :cascade do |t|
    t.integer 'blog_entry_id', null: false
    t.binary  'picture_data'
    t.string  'picture_content_type', limit: 100
  end

  create_table 'users', force: :cascade do |t|
    t.string   'salted_password', limit: 40,             null: false
    t.string   'email',           limit: 60,             null: false
    t.string   'first_name',      limit: 40
    t.string   'last_name',       limit: 40
    t.string   'salt',            limit: 40, null: false
    t.integer  'verified', default: 0
    t.string   'role',            limit: 40
    t.string   'security_token',  limit: 40
    t.datetime 'token_expiry'
    t.integer  'deleted', default: 0
    t.datetime 'delete_after'
  end
end
