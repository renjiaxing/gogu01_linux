# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!

ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.perform_deliveries = true

ActionMailer::Base.smtp_settings = {
    :address              => "smtp.163.com",
    :port                 => "25",
    :domain               => "163.com",
    :user_name            => "ren_jiaxing1984@163.com",
    :password             => "sap123",
    :authentication       => :login
    # :enable_starttls_auto => true
}