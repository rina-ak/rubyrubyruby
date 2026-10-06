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

ActiveRecord::Schema[8.1].define(version: 2026_10_06_064841) do
  create_table "album_proposals", force: :cascade do |t|
    t.string "artist"
    t.datetime "created_at", null: false
    t.text "notes"
    t.string "title"
    t.datetime "updated_at", null: false
  end

  create_table "albums", force: :cascade do |t|
    t.string "artist"
    t.string "cover_url"
    t.datetime "created_at", null: false
    t.string "duration"
    t.string "genre"
    t.text "intro_text"
    t.string "release_type"
    t.integer "release_year"
    t.string "title"
    t.datetime "updated_at", null: false
  end

  create_table "comments", force: :cascade do |t|
    t.integer "album_id", null: false
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["album_id"], name: "index_comments_on_album_id"
  end

  create_table "thematic_sections", force: :cascade do |t|
    t.integer "album_id", null: false
    t.text "content"
    t.datetime "created_at", null: false
    t.string "section_type"
    t.string "title"
    t.datetime "updated_at", null: false
    t.index ["album_id"], name: "index_thematic_sections_on_album_id"
  end

  add_foreign_key "comments", "albums"
  add_foreign_key "thematic_sections", "albums"
end
