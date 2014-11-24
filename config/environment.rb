# Load the Rails application.
require File.expand_path('../application', __FILE__)

ActionMailer::Base.delivery_method = :smtp

ActionMailer::Base.smtp_settings = {
    :address              => "smtp.gmail.com",
    :port                 => "587",
    :domain               => "gmail.com",
    :enable_starttls_auto => true,
    :authentication => :login,
    :user_name => "disruptr123@gmail.com",
    :password =>                                                                                                                                                                                                            "",
}

# Initialize the Rails application.
Rails.application.initialize!
