require "#{Rails.root}/populate_db.rb"

namespace :db do
  desc 'Populate DB with sample app-specific data'
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    populate_db
  end
end
