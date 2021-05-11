class CreateResponses < ActiveRecord::Migration[5.2]
  def change
    create_table :responses do |t|
      t.references :leadership_survey, foreign_key: true
      t.integer :user_type
      t.references :user, foreign_key: true
      t.boolean :completed,default: false

      t.timestamps
    end
  end
end
