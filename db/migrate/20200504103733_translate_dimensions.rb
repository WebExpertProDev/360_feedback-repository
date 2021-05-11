class TranslateDimensions < ActiveRecord::Migration[5.2]
  def self.up
    Dimension.create_translation_table!({
      :name => :string
    }, {
      :migrate_data => true,
      :remove_source_columns => true
    })
  end

  def self.down
    Dimension.drop_translation_table! :migrate_data => true
  end
end
