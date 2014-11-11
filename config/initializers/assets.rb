# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )

Rails.application.config.assets.paths << "#{Rails.root}/vendor/assets/*"
Rails.application.config.assets.paths << "#{Rails.root}/vendor/assets/fonts/theme"
Rails.application.config.assets.paths << "#{Rails.root}/vendor/assets/stylesheets"
Rails.application.config.assets.paths << "#{Rails.root}/vendor/assets/images"

Rails.application.config.assets.precompile << Proc.new { |path|
  if path =~ /\.(eot|svg|ttf|woff)\z/
    true
  end }

#Rails.application.config.assets.precompile += %w( ui-sam.jpg )
Rails.application.config.assets.precompile += %w[*.png *.jpg *.jpeg *.gif]
Rails.application.config.assets.precompile += %w( theme/jquery-1.8.3.min.js )

