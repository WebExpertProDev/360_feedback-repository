class TranslateQuestionOptions < ActiveRecord::Migration[5.2]
  def self.up
    QuestionOption.create_translation_table!({
      :full_text => :text
    }, {
      :migrate_data => true,
      :remove_source_columns => true
    })
  end

  def self.down
    QuestionOption.drop_translation_table! :migrate_data => true
  end
end
