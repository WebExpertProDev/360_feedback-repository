class AddAttachmentExcelFileToDocuments < ActiveRecord::Migration[5.2]
  def self.up
    change_table :documents do |t|
      t.attachment :excel_file
    end
  end

  def self.down
    remove_attachment :documents, :excel_file
  end
end
