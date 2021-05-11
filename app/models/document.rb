# frozen_string_literal: true

# :Document Model for Attahing documents:
class Document < ApplicationRecord
  belongs_to :owner, polymorphic: true
  has_attached_file :excel_file
  validates_attachment_content_type :excel_file,
                                    content_type: [/\.xlsx?$/, /\.spreadsheet$/]
end
