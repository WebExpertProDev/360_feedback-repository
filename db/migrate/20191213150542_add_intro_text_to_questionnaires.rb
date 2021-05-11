class AddIntroTextToQuestionnaires < ActiveRecord::Migration[5.2]
  def change
    add_column :questionnaires, :intro_text, :text
  end
end
