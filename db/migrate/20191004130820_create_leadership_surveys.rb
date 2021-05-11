class CreateLeadershipSurveys < ActiveRecord::Migration[5.2]
  def change
    create_table :leadership_surveys do |t|
      t.references :user, foreign_key: true
      t.string :slug
      t.string :name
      t.boolean :status,default: false
      t.boolean :both_statements,default: false
      t.integer :allquestions,array: true,default: []

      t.timestamps
    end
    add_index :leadership_surveys, :slug
  end
end
