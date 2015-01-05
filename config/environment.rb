# Load the Rails application.
require File.expand_path('../application', __FILE__)

ActionMailer::Base.delivery_method = :smtp



ActionMailer::Base.smtp_settings = {
    :address              => "smtp.gmail.com",
    :port                 => 587,
    :domain               => 'gmail.com',
    :user_name            => 'beefbet@gmail.com',
    :password             => 'beefbet',
    :authentication       => 'plain',
    :enable_starttls_auto => true
}

# Initialize the Rails application.
Rails.application.initialize!
