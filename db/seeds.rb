# --------> Usar com rake db:reset <------------

require "#{Rails.root}/football_data.rb"
require "#{Rails.root}/football_data_db.rb"

fdata = FootballData.new
fdata.load_all_fixtures

puts 'Saving fixtures to database...'
fdatadb = FootballDataDB.new fdata
fdatadb.save_leagues_to_db

puts "First game: #{Game.all.order(time: :asc).first.time.to_s}"
puts "Last game: #{Game.all.order(time: :asc).last.time.to_s}"
puts "Last updated: #{Game.where.not(team1_goals: -1).order(:time).last.time}"
puts "Next update: #{Game.where(team1_goals: -1).order(:time).first.time}"

User.create! :email => 'beef1234@gmail.com', :password => 'beef1234', :password_confirmation => 'beef1234'

puts 'Creating league and adding users...'
league_owner = User.create! :email => 'owner@a.com', :password => 'beef1234', :password_confirmation => 'beef1234'
league = League.create! name: "Bife com Atum", score_correct: 150, score_difference: 100, score_prediction: 75,
                        owner: league_owner, championships: [Championship.take]
league.users << (User.create! :email => 'a@a.com', :password => 'beef1234', :password_confirmation => 'beef1234')
league.users << (User.create! :email => 'b@a.com', :password => 'beef1234', :password_confirmation => 'beef1234')
league.users << (User.create! :email => 'c@a.com', :password => 'beef1234', :password_confirmation => 'beef1234')

puts 'Filling random bets...'
fdatadb.fill_random_bets league