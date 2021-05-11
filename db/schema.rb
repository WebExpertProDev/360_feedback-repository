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

ActiveRecord::Schema.define(version: 2020_05_04_125103) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "dimension_translations", force: :cascade do |t|
    t.bigint "dimension_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.index ["dimension_id"], name: "index_dimension_translations_on_dimension_id"
    t.index ["locale"], name: "index_dimension_translations_on_locale"
  end

  create_table "dimensions", force: :cascade do |t|
    t.bigint "questionnaire_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["questionnaire_id"], name: "index_dimensions_on_questionnaire_id"
  end

  create_table "documents", force: :cascade do |t|
    t.string "owner_type"
    t.bigint "owner_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "excel_file_file_name"
    t.string "excel_file_content_type"
    t.bigint "excel_file_file_size"
    t.datetime "excel_file_updated_at"
    t.index ["owner_type", "owner_id"], name: "index_documents_on_owner_type_and_owner_id"
  end

  create_table "leadership_surveys", force: :cascade do |t|
    t.bigint "user_id"
    t.string "slug"
    t.string "name"
    t.boolean "status", default: false
    t.boolean "both_statements", default: false
    t.integer "allquestions", default: [], array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "survey_type"
    t.index ["slug"], name: "index_leadership_surveys_on_slug"
    t.index ["user_id"], name: "index_leadership_surveys_on_user_id"
  end

  create_table "leadership_surveys_questionnaires", id: false, force: :cascade do |t|
    t.integer "leadership_survey_id"
    t.integer "questionnaire_id"
  end

  create_table "logbooks", force: :cascade do |t|
    t.bigint "user_id"
    t.text "overview_1"
    t.text "overview_2"
    t.text "overview_3"
    t.text "overview_4"
    t.text "overview_5"
    t.text "overview_6"
    t.string "overview_7"
    t.text "overview_8"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "leadership_survey_id"
    t.index ["leadership_survey_id"], name: "index_logbooks_on_leadership_survey_id"
    t.index ["user_id"], name: "index_logbooks_on_user_id"
  end

  create_table "question_option_translations", force: :cascade do |t|
    t.bigint "question_option_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "full_text"
    t.index ["locale"], name: "index_question_option_translations_on_locale"
    t.index ["question_option_id"], name: "index_question_option_translations_on_question_option_id"
  end

  create_table "question_options", force: :cascade do |t|
    t.bigint "question_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "option_type"
    t.index ["question_id"], name: "index_question_options_on_question_id"
  end

  create_table "question_statement_translations", force: :cascade do |t|
    t.bigint "question_statement_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "full_text"
    t.index ["locale"], name: "index_question_statement_translations_on_locale"
    t.index ["question_statement_id"], name: "index_question_statement_translations_on_question_statement_id"
  end

  create_table "question_statements", force: :cascade do |t|
    t.bigint "question_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "statement_type"
    t.index ["question_id"], name: "index_question_statements_on_question_id"
  end

  create_table "questionnaire_translations", force: :cascade do |t|
    t.bigint "questionnaire_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.text "intro_text"
    t.index ["locale"], name: "index_questionnaire_translations_on_locale"
    t.index ["questionnaire_id"], name: "index_questionnaire_translations_on_questionnaire_id"
  end

  create_table "questionnaires", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "priority"
  end

  create_table "questions", force: :cascade do |t|
    t.bigint "questionnaire_id"
    t.bigint "dimension_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["dimension_id"], name: "index_questions_on_dimension_id"
    t.index ["questionnaire_id"], name: "index_questions_on_questionnaire_id"
  end

  create_table "responses", force: :cascade do |t|
    t.bigint "leadership_survey_id"
    t.integer "user_type"
    t.bigint "user_id"
    t.boolean "completed", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["leadership_survey_id"], name: "index_responses_on_leadership_survey_id"
    t.index ["user_id"], name: "index_responses_on_user_id"
  end

  create_table "submissions", force: :cascade do |t|
    t.bigint "response_id"
    t.bigint "question_id"
    t.bigint "question_statement_id"
    t.integer "semantic_score"
    t.integer "scaled_score"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["question_id"], name: "index_submissions_on_question_id"
    t.index ["question_statement_id"], name: "index_submissions_on_question_statement_id"
    t.index ["response_id"], name: "index_submissions_on_response_id"
  end

  create_table "test_invites", force: :cascade do |t|
    t.bigint "inviter_id"
    t.bigint "invitee_id"
    t.bigint "leadership_survey_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["invitee_id"], name: "index_test_invites_on_invitee_id"
    t.index ["inviter_id"], name: "index_test_invites_on_inviter_id"
    t.index ["leadership_survey_id"], name: "index_test_invites_on_leadership_survey_id"
  end

  create_table "users", force: :cascade do |t|
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
    t.string "provider"
    t.string "uid"
    t.string "name"
    t.date "dob"
    t.string "gender"
    t.string "profile_pic_file_name"
    t.string "profile_pic_content_type"
    t.bigint "profile_pic_file_size"
    t.datetime "profile_pic_updated_at"
    t.string "phone_number"
    t.boolean "admin", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "balance_cents", default: 0, null: false
    t.string "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer "invitation_limit"
    t.string "invited_by_type"
    t.bigint "invited_by_id"
    t.integer "invitations_count", default: 0
    t.boolean "corporate_user", default: false
    t.string "organization_name"
    t.string "surname"
    t.integer "age"
    t.string "country"
    t.string "highest_education"
    t.string "industry"
    t.boolean "completed", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["invitation_token"], name: "index_users_on_invitation_token", unique: true
    t.index ["invitations_count"], name: "index_users_on_invitations_count"
    t.index ["invited_by_id"], name: "index_users_on_invited_by_id"
    t.index ["invited_by_type", "invited_by_id"], name: "index_users_on_invited_by_type_and_invited_by_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "variables", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "value", precision: 20, scale: 2
    t.index ["name"], name: "index_variables_on_name"
  end

  add_foreign_key "dimensions", "questionnaires"
  add_foreign_key "leadership_surveys", "users"
  add_foreign_key "logbooks", "users"
  add_foreign_key "question_options", "questions"
  add_foreign_key "question_statements", "questions"
  add_foreign_key "questions", "dimensions"
  add_foreign_key "questions", "questionnaires"
  add_foreign_key "responses", "leadership_surveys"
  add_foreign_key "responses", "users"
  add_foreign_key "submissions", "question_statements"
  add_foreign_key "submissions", "questions"
  add_foreign_key "submissions", "responses"
  add_foreign_key "test_invites", "leadership_surveys"
  add_foreign_key "test_invites", "users", column: "invitee_id"
  add_foreign_key "test_invites", "users", column: "inviter_id"
end
