class AddStatementTypeToQuestionStatements < ActiveRecord::Migration[5.2]
  def change
    add_column :question_statements, :statement_type, :integer
  end
end
