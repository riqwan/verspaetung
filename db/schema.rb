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

ActiveRecord::Schema.define(version: 2019_04_21_101102) do

  create_table "lines", force: :cascade do |t|
    t.string "line_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "transport_delays", force: :cascade do |t|
    t.integer "transport_line_id"
    t.integer "delay"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["transport_line_id"], name: "index_transport_delays_on_transport_line_id"
  end

  create_table "transport_lines", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "transport_stops", force: :cascade do |t|
    t.integer "x"
    t.integer "y"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "transport_times", force: :cascade do |t|
    t.integer "transport_stop_id"
    t.integer "transport_line_id"
    t.datetime "time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["transport_line_id"], name: "index_transport_times_on_transport_line_id"
    t.index ["transport_stop_id"], name: "index_transport_times_on_transport_stop_id"
  end

end
