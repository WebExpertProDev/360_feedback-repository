# frozen_string_literal: true

module Admin
  # :Class for Create a Document for the User:
  class BulkUsersUpload < BaseInteractor
    def call
      document = create_document
      if document.save
        response = Admin::OpenUsersFile.call(
          document: document
        )
        return unless response[:success] == true

        context.success = true
      else
        context.fail! error: document.errors.full_messages.to_sentence
      end
    end

    def create_document
      context.current_user.build_document(
        context.user_excel_file_params
      )
    end
  end
end
