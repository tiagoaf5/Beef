require "#{Rails.root}/football_data.rb"
require 'rubygems'
require 'rufus/scheduler'

# turn off 'async' warning from RailsDevelopmentBoost
RailsDevelopmentBoost.async = false if defined?(RailsDevelopmentBoost)
scheduler = Rufus::Scheduler.new
fdata = FootballData.new
fdata.load_all_fixtures

def schedule_update scheduler, fdata
  next_update_datetime = (DateTime.parse(fdata.next_update_time) + 110.minutes).to_s

  if next_update_datetime > DateTime.now
    scheduler.at next_update_datetime do
      Rails.logger.info "Launching an update because of #{fdata.newest_to_update}"
      fdata.download_all_fixtures
      schedule_update scheduler, fdata
    end
  end
end

schedule_update scheduler, fdata