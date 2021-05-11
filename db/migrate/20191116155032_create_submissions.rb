class CreateSubmissions < ActiveRecord::Migration[5.2]
  def change
    create_table :submissions do |t|
      t.references :response, foreign_key: true
      t.references :question, foreign_key: true
      t.references :question_statement, foreign_key: true
      # t.references :leadership_survey, foreign_key: true
      t.integer :semantic_score
      t.integer :scaled_score

      t.timestamps
    end
  end
end
