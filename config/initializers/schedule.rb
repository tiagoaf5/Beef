require "#{Rails.root}/football_data.rb"
require "#{Rails.root}/football_data_db.rb"
require 'rubygems'
require 'rufus/scheduler'

# turn off 'async' warning from RailsDevelopmentBoost
RailsDevelopmentBoost.async = false if defined?(RailsDevelopmentBoost)

scheduler = Rufus::Scheduler.new

fdata = FootballData.new
fdata.load_all_fixtures
fdatadb = FootballDataDB.new fdata

def schedule_update scheduler, fdatadb
  next_update_datetime = (DateTime.parse(fdatadb.football_data.next_update_time) + 110.minutes).to_s

  if next_update_datetime
    scheduler.at next_update_datetime do
      Rails.logger.info "Launching an update because of #{fdatadb.football_data.newest_to_update}"
      fdatadb.download_all_fixtures
      schedule_update scheduler, fdatadb
    end
  end
end

schedule_update scheduler, fdatadb