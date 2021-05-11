# frozen_string_literal: true

module Admin
  # :Class for Opening the Document using Roo Ge,:
  class OpenUsersFile < BaseInteractor
    def call
      spreadsheet = Roo::Spreadsheet.open(
        context.document.excel_file.path
      )
      first_sheet = spreadsheet.sheet(0)
      first_sheet.parse.each do |row|
        create_user(row) if User.find_by_email(row.second).nil?
      end
      context.success = true
    end

    def create_user(row)
      user = User.create!(
        name: row.first,
        email: row.second,
        password: row.third,
        password_confirmation: row.third,
        organization_name: row.fourth,
        corporate_user: true
      )
      send_email(user, row)
    end

    def send_email(user, row)
      BasicMailer.send_excel_user_invite(user, row.third, row.fifth).deliver_later
    end
  end
end
