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

ActiveRecord::Schema[7.0].define(version: 2023_02_06_005014) do
  create_table "images", force: :cascade do |t|
    t.string "app_path"
    t.string "name_detail"
    t.integer "subject_id", null: false
    t.integer "location_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "date_taken"
    t.string "camera_body"
    t.decimal "focal_length"
    t.decimal "aperture"
    t.decimal "shutter"
    t.integer "iso"
    t.integer "month_id"
    t.integer "import_id", null: false
    t.string "content_hash"
    t.index ["app_path"], name: "index_images_on_app_path", unique: true
    t.index ["import_id"], name: "index_images_on_import_id"
    t.index ["location_id"], name: "index_images_on_location_id"
    t.index ["month_id"], name: "index_images_on_month_id"
    t.index ["subject_id"], name: "index_images_on_subject_id"
  end

  create_table "imports", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "locations", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_locations_on_name", unique: true
  end

  create_table "months", force: :cascade do |t|
    t.string "month"
    t.integer "month_index"
    t.integer "year"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "subjects", force: :cascade do |t|
    t.string "name"
    t.string "species"
    t.string "content_hash"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_subjects_on_name", unique: true
    t.index ["species"], name: "index_subjects_on_species", unique: true
  end

  add_foreign_key "images", "imports"
  add_foreign_key "images", "locations"
  add_foreign_key "images", "months"
  add_foreign_key "images", "subjects"
end
