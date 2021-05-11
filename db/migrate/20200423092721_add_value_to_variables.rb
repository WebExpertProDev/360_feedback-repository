class AddValueToVariables < ActiveRecord::Migration[5.2]
  def change
    add_column :variables, :value, :decimal, precision: 20, scale: 2
  end
end
