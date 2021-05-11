class CreateTestInvites < ActiveRecord::Migration[5.2]
  def change
    create_table :test_invites do |t|
      t.references :inviter, references: :users, foreign_key: { to_table: :users}
      t.references :invitee, references: :users, foreign_key: { to_table: :users}
      t.references :leadership_survey, foreign_key: true
      t.timestamps
    end
  end
end
