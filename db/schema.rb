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

ActiveRecord::Schema.define(version: 20180421001812) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "applications", force: :cascade do |t|
    t.bigint "person_id"
    t.string "locale"
    t.jsonb "fields", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "position_id"
    t.date "starting_date"
    t.index ["person_id"], name: "index_applications_on_person_id"
    t.index ["position_id"], name: "index_applications_on_position_id"
  end

  create_table "attachments", force: :cascade do |t|
    t.string "file_uid"
    t.string "file_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "boards", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
  end

  create_table "boards_phases", force: :cascade do |t|
    t.bigint "board_id"
    t.bigint "phase_id"
    t.integer "position", default: 1
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["board_id"], name: "index_boards_phases_on_board_id"
    t.index ["phase_id"], name: "index_boards_phases_on_phase_id"
  end

  create_table "email_addresses", force: :cascade do |t|
    t.string "address"
    t.bigint "person_id"
    t.index ["person_id"], name: "index_email_addresses_on_person_id"
  end

  create_table "email_labels", force: :cascade do |t|
    t.string "name"
    t.string "google_label_id"
    t.bigint "phase_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["phase_id"], name: "index_email_labels_on_phase_id"
  end

  create_table "email_messages", force: :cascade do |t|
    t.bigint "email_thread_id"
    t.string "google_message_id"
    t.string "google_timestamp"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "from_address"
    t.string "to_addresses", array: true
    t.index ["email_thread_id"], name: "index_email_messages_on_email_thread_id"
  end

  create_table "email_persons_threads", force: :cascade do |t|
    t.bigint "person_id"
    t.bigint "email_thread_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email_thread_id"], name: "index_email_persons_threads_on_email_thread_id"
    t.index ["person_id"], name: "index_email_persons_threads_on_person_id"
  end

  create_table "email_template_translations", force: :cascade do |t|
    t.integer "email_template_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "subject"
    t.text "body"
    t.index ["email_template_id"], name: "index_email_template_translations_on_email_template_id"
    t.index ["locale"], name: "index_email_template_translations_on_locale"
  end

  create_table "email_templates", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "email_threads", force: :cascade do |t|
    t.string "google_thread_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "subject"
    t.string "google_create_timestamp"
    t.string "google_update_timestamp"
  end

  create_table "persons", force: :cascade do |t|
    t.string "name"
    t.string "lastname"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "uuid"
  end

  create_table "persons_phases", force: :cascade do |t|
    t.bigint "phase_id"
    t.bigint "person_id"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["person_id"], name: "index_persons_phases_on_person_id"
    t.index ["phase_id"], name: "index_persons_phases_on_phase_id"
  end

  create_table "phases", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "initial", default: false
    t.uuid "uuid"
  end

  create_table "phases_callbacks", force: :cascade do |t|
    t.string "title"
    t.bigint "phase_id"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["phase_id"], name: "index_phases_callbacks_on_phase_id"
  end

  create_table "phases_callbacks_email_templates", force: :cascade do |t|
    t.bigint "email_template_id"
    t.bigint "phases_callback_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email_template_id"], name: "index_phases_callbacks_email_templates_on_email_template_id"
    t.index ["phases_callback_id"], name: "index_phases_callbacks_email_templates_on_phases_callback_id"
  end

  create_table "position_translations", force: :cascade do |t|
    t.integer "position_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title", null: false
    t.index ["locale"], name: "index_position_translations_on_locale"
    t.index ["position_id"], name: "index_position_translations_on_position_id"
  end

  create_table "positions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "hidden", default: false
    t.integer "time_interval_cd", default: 0
  end

  create_table "positions_form_field_translations", force: :cascade do |t|
    t.integer "positions_form_field_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "label", null: false
    t.index ["locale"], name: "index_positions_form_field_translations_on_locale"
    t.index ["positions_form_field_id"], name: "index_9939125a30cc4053c2ebf423926168a906b53a10"
  end

  create_table "positions_form_fields", force: :cascade do |t|
    t.bigint "recruitment_form_id"
    t.jsonb "options", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "position", default: 0
    t.integer "requirement_id"
    t.integer "form_cd"
    t.boolean "optional", default: false
    t.index ["recruitment_form_id"], name: "index_positions_form_fields_on_recruitment_form_id"
  end

  create_table "positions_recruitment_forms", force: :cascade do |t|
    t.bigint "position_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["position_id"], name: "index_positions_recruitment_forms_on_position_id"
  end

  create_table "positions_requirement_translations", force: :cascade do |t|
    t.integer "positions_requirement_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "label", null: false
    t.index ["locale"], name: "index_positions_requirement_translations_on_locale"
    t.index ["positions_requirement_id"], name: "index_758f0a08048846c3abd13663ef37786654691ba1"
  end

  create_table "recruitment_info_translations", force: :cascade do |t|
    t.integer "recruitment_info_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "content"
    t.index ["locale"], name: "index_recruitment_info_translations_on_locale"
    t.index ["recruitment_info_id"], name: "index_recruitment_info_translations_on_recruitment_info_id"
  end

  create_table "recruitment_infos", force: :cascade do |t|
    t.integer "singleton_guard", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "applications", "persons"
  add_foreign_key "applications", "positions"
  add_foreign_key "boards_phases", "boards"
  add_foreign_key "boards_phases", "phases"
  add_foreign_key "email_addresses", "persons"
  add_foreign_key "email_labels", "phases"
  add_foreign_key "email_messages", "email_threads"
  add_foreign_key "email_persons_threads", "email_threads"
  add_foreign_key "email_persons_threads", "persons"
  add_foreign_key "persons_phases", "persons"
  add_foreign_key "persons_phases", "phases"
  add_foreign_key "phases_callbacks", "phases"
  add_foreign_key "phases_callbacks_email_templates", "phases_callbacks"
  add_foreign_key "positions_form_fields", "positions_recruitment_forms", column: "recruitment_form_id"
  add_foreign_key "positions_recruitment_forms", "positions"
end
