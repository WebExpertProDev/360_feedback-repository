class CreateDimensions < ActiveRecord::Migration[5.2]
  def change
    create_table :dimensions do |t|
      t.string :name
      t.references :questionnaire, foreign_key: true

      t.timestamps
    end
  end
end
