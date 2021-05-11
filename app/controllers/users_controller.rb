class UsersController < ApplicationController
  before_action :authenticate_user!

  def edit
    @user = User.find(params[:id])
  end

  def logbook
    current_user.build_logbook if current_user.logbook.nil?
  end

  def save_logbook
    @user = current_user
    overview_7 = params.to_unsafe_h[:user][:logbook_attributes][:overview_7].values.zip
    # logbook_params[:overview_7] = lo
    if @user.update(logbook_params) && @user.logbook.update(overview_7: overview_7)
      redirect_to logbook_path, notice: "Personal Logbook saved successfully"
    else
      redirect_to logbook_path, alert: @user.errors.full_messages.join
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      complete_user(@user)
      redirect_to profile_path, notice: 'User profile updated successfully'
    else
      redirect_to profile_path, notice: @user.errors.full_messages.join
    end
  end

  private

  def user_completed?(user)
    user.name.present? && user.surname.present? &&
      user.age.present? && user.gender.present? &&
      user.country.present? && user.highest_education.present? &&
      user.phone_number.present? && user.industry.present?
  end

  def complete_user(user)
    if user_completed?(user)
      user.update(completed: true)
    else
      user.update(completed: false)
    end
  end

  def user_params
    params.require(:user).permit(:name, :surname, :age, :gender,
                                 :country, :highest_education, :phone_number,
                                 :dob, :industry, :profile_pic)
  end
end
