class AddOptionTypeToQuestionOptions < ActiveRecord::Migration[5.2]
  def change
    add_column :question_options, :option_type, :integer
  end
end
