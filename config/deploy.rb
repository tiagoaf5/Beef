# config valid only for current version of Capistrano
lock '3.3.3'

# Define the name of the application
set :application, 'beef'

# Define where can Capistrano access the source repository
# set :repo_url, 'https://github.com/[user name]/[application name].git'
set :scm, :git
set :repo_url, 'https://github.com/tiagoaf5/LDSO-2014-T1.3.git'

# Define where to put your application code
set :deploy_to, "/home/rails"

set :pty, true

set :format, :pretty

# Set the post-deployment instructions here.
# Once the deployment is complete, Capistrano
# will begin performing them as described.
# To learn more about creating tasks,
# check out:
# http://capistranorb.com/

namespace :deploy do

  desc 'Install missing gems'
  task :install_gems do
    run("RAILS_ENV=production bundle install")
  end

  desc 'Migrate database'
  task :migrate_db do
    run("bundle exec rake db:migrate RAILS_ENV=production")
  end

  desc 'Precompile assets'
  task :precompile_assets do
    run("undle exec rake assets:precompile RAILS_ENV=production")
  end

  desc 'Clear cache'
  task :clear_cache do
    within release_path do
      execute :rake, 'cache:clear'
    end
  end

  desc 'Restart unicorn'
  task :restart_unicorn do
    run("service unicorn restart")
  end

  after :publishing, :install_gems
  after :install_gems, :migrate_db
  after :migrate_db, :precompile_assets
  after :precompile_assets, :clear_cache
  after :clear_cache, :restart_unicorn


end
