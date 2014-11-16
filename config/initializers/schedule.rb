require "#{Rails.root}/football_data.rb"
require 'rubygems'
require 'rufus/scheduler'

# turn off 'async' warning from RailsDevelopmentBoost
RailsDevelopmentBoost.async = false if defined?(RailsDevelopmentBoost)
scheduler = Rufus::Scheduler.new
FootballData.instance.load_all_fixtures

def schedule_update scheduler
  scheduler.at( (DateTime.parse(FootballData.instance.next_update_time) + 110.minutes).to_s ) do
    Rails.logger.info "Launching an update because of #{FootballData.instance.newest_to_update}"
    FootballData.instance.download_all_fixtures
    schedule_update scheduler
  end
end

schedule_update scheduler