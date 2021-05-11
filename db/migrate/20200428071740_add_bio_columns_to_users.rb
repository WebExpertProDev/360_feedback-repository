class AddBioColumnsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :surname, :string
    add_column :users, :age, :integer
    add_column :users, :country, :string
    add_column :users, :highest_education, :string
    add_column :users, :industry, :string
    add_column :users, :completed, :boolean, default: false
  end
end
