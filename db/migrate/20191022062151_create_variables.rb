class CreateVariables < ActiveRecord::Migration[5.2]
  def change
    create_table :variables do |t|
      t.string :name
      t.text :description

      t.timestamps
    end
    add_index :variables, :name
  end
end
