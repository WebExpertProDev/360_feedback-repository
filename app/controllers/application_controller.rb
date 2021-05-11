# frozen_string_literal: true

# :Application Controller for Handling All site actions:
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper ApplicationHelper
  before_action :configure_permitted_parameters, if: :devise_controller?
  # before_action :set_locale

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, alert: exception.message
  end

  # def set_locale
  #   I18n.locale = params[:locale] if params[:locale].present?
  # end

  # def default_url_options(options = {})
  #   {locale: I18n.locale}
  # end

  def after_sign_in_path_for(resource)
    stored_location_for(resource) ||
      if resource.is_a?(User) && resource.admin?
        admin_panel_path
      elsif resource.is_a?(User)
        if resource.completed?
          user_panel_path
        else
          profile_path
        end
      else
        super
      end
  end

  def authenticate_admin
    redirect_back(fallback_location: root_url,alert: "You don't have permissions to view this page.") if !(user_signed_in? and current_user.admin)
  end

  def authenticate_user
    if !(user_signed_in? and current_user.admin == false)
      redirect_back(fallback_location: root_url,alert: "You don't have permissions to access this page.")
    end
  end 

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:invite, keys: [:email, :test_id])
    devise_parameter_sanitizer.permit(:accept_invitation, keys: [:first_name, :last_name, :phone])
  end
end
