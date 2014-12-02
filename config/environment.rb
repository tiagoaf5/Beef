# Load the Rails application.
require File.expand_path('../application', __FILE__)

ActionMailer::Base.delivery_method = :smtp



ActionMailer::Base.smtp_settings = {
    :address              => "smtp.fe.up.pt",
    :port                 => "465",
}

# Initialize the Rails application.
Rails.application.initialize!
