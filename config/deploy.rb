# config valid only for current version of Capistrano
lock '3.3.3'

# name of the application
set :application, 'beef'

set :scm, :git
set :repo_url, 'git@github.com:tiagoaf5/LDSO-2014-T1.3.git'
set :ssh_options, { forward_agent: 'true', keys: "~/.ssh/id_rsa.pub" }
set :branch, 'master'
set :default_run_options, {pty: 'true'}
set :rvm_ruby_string, 'ruby-2.1.3'

# Where to put application code
set :deploy_to, "/home/rails"

set :pty, true

set :format, :pretty

# Post-deployment instructions
# Once the deployment is complete, Capistrano
# will begin performing them as described.

namespace :deploy do

  desc 'Install missing gems'
  task :install_gems do
    on roles(:all) do
      execute "(cd /home/rails/current; RAILS_ENV=production bundle install)"
    end
  end

  desc 'Migrate database'
  task :migrate_db do
    on roles(:all) do
      execute "(cd /home/rails/current; RAILS_ENV=production rake db:migrate)"
    end
  end

  desc 'Precompile assets'
  task :precompile_assets do
    on roles(:all) do
      execute "(cd /home/rails/current; RAILS_ENV=production rake assets:precompile)"
    end
  end

  desc 'Restart unicorn'
  task :restart_unicorn do
    on roles(:all) do
      execute "service unicorn restart"
    end
  end

  after :publishing, :install_gems
  after :install_gems, :migrate_db
  after :migrate_db, :precompile_assets
  after :precompile_assets, :restart_unicorn

  #On first deploy manually run on the server rake db:populate

end
