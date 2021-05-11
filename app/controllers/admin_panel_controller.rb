class AdminPanelController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource class: false
  
  def index
    @users = User.where.not(id: current_user.id)
    @questionnaires = Questionnaire.all
  end

  def users
    @users = User.where.not(id: current_user.id)
  end

  def questionnaires
  	@questionnaires = Questionnaire.all.includes(:dimensions)
  end

  def edit_intro_save
    # @questionnaires

    # @intro = Variable.find_or_initialize_by(name: "INTRODUCTION")
    # params[:questionnaire].each do |k,v|
    #   # byebug
    #   Questionnaire.find_by_id(k)&.update!(intro_text: v[:intro_text])
    # end
    @success = Questionnaire.update(params[:questionnaire].keys, params[:questionnaire].values)
    # redirect_to request.referer,notice: "Text Updated"

    # @success = Questionnaire.update_all([{id: 1,intro_text: '123'},{id: 2,intro_text: '321'}])
    # @intro.description = params[:text]
    # @success = @intro.save!
  end

  def bulk_users_upload
    return unless params[:user].present?

    response = Admin::BulkUsersUpload.call(
      current_user: current_user,
      user_excel_file_params: user_excel_file_params
    )
    if response[:success] == true
      redirect_to admin_users_path, notice: 'Bulk Users Added Successfully'
    else
      redirect_to admin_users_path, alert: "Error #{response[:error]}"
    end
  end

  def user_excel_file_params
    params.require(:user).permit(:excel_file)
  end
end
