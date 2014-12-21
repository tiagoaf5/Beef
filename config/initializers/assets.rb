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
Rails.application.config.assets.paths << "#{Rails.root}/vendor/assets/stylesheets/theme"
Rails.application.config.assets.paths << "#{Rails.root}/vendor/assets/javascripts"
Rails.application.config.assets.paths << "#{Rails.root}/vendor/assets/javascripts/theme"

Rails.application.config.assets.precompile << Proc.new { |path|
  if path =~ /\.(eot|svg|ttf|woff|otf)\z/
    true
  end }

Rails.application.config.assets.precompile << Proc.new do |path|
  if path =~ /\.(css|js)\z/
    full_path = Rails.application.assets.resolve(path).to_path
    app_assets_path = Rails.root.join('app', 'assets').to_path
    if full_path.starts_with? app_assets_path
      puts "including asset: " + full_path
      true
    else
      puts "include vendor/asset: " + full_path
      true
    end
  else
    false
  end
end

#Rails.application.config.assets.precompile += %w( ui-sam.jpg )
Rails.application.config.assets.precompile += %w[*.png *.jpg *.jpeg *.gif]
Rails.application.config.assets.precompile += %w( theme/jquery-1.8.3.min.js )
Rails.application.config.assets.precompile += %w( theme/jquery-1.8.3.min.js )

Rails.application.config.assets.precompile += %w( theme/bootstrap-fileupload/bootstrap-fileupload.js )
Rails.application.config.assets.precompile += %w( theme/bootstrap-fileupload/bootstrap-fileupload.css )
