class CreateLogbooks < ActiveRecord::Migration[5.2]
  def change
    create_table :logbooks do |t|
      t.references :user, foreign_key: true
      t.text :overview_1
      t.text :overview_2
      t.text :overview_3
      t.text :overview_4
      t.text :overview_5
      t.text :overview_6
      t.string :overview_7
      t.text :overview_8

      t.timestamps
    end
  end
end
