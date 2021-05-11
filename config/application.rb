# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'
Bundler.require(*Rails.groups)
module Freelance
  # Main Configuration Class for the Application
  class Application < Rails::Application
    config.load_defaults 5.1
    config.app_generators.scaffold_controller = :scaffold_controller
    config.time_zone = 'Asia/Karachi'
    config.active_record.default_timezone = :local
    config.generators do |g|
      g.assets  false
      g.helper  false
      g.test_framework nil
      g.jbuilder  false
      g.decorator false
    end

    config.i18n.load_path += Dir[Rails.root.join('my', 'locales',
                                                 '**', '*.{rb,yml}')]
    config.i18n.available_locales = %i[en fr es]
    config.i18n.default_locale = :en
  end
end
