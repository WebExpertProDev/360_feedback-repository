class TranslateQuestionnaires < ActiveRecord::Migration[5.2]
  def self.up
    Questionnaire.create_translation_table!({
      :name => :string,
      :intro_text => :text
    }, {
      :migrate_data => true,
      :remove_source_columns => true
    })
  end

  def self.down
    Questionnaire.drop_translation_table! :migrate_data => true
  end
end
