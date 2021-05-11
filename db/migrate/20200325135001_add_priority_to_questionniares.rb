class AddPriorityToQuestionniares < ActiveRecord::Migration[5.2]
  def change
    add_column :questionnaires, :priority, :integer
  end
end
