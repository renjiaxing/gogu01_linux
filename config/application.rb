require File.expand_path('../boot', __FILE__)

require 'rails/all'
require 'xinge'
# require 'Wxxinge'
# require 'Faraday'

Xinge.configure do |config|
  # config[:android_accessId] = Your android access id
  # config[:android_secretKey] = 'Your secret key xxx'
  config[:ios_accessId] = 2200120344
  config[:ios_secretKey] = '72371c5e43c99b8a4a845ff995bef03c'
  config[:env] = Rails.env # if you are not in a rails app, you can set it config[:env]='development' or config[:env]='production', it is 'development' default.
end

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Gogu01
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'
    # config.time_zone = 'Beijing'
    # config.active_record.default_timezone = :local

    # config.autoload_paths += %W(#{config.root}/app/grape)

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
    config.i18n.default_locale = 'zh-CN'
  end
end
