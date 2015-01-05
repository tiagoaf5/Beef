require "#{Rails.root}/football_data.rb"
require "#{Rails.root}/football_data_db.rb"

def populate_db
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
  league_owner = User.create! :image => 'http://fc04.deviantart.net/fs71/i/2014/003/a/6/male_stock_249_by_birdsistersstock-d6ga4ec.jpg', :name => 'João Leitão', :email => 'joaoleitao@gmail.com', :password => 'beef1234', :password_confirmation => 'beef1234'
  league_owner2 = User.create! :image => 'https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcSsvrEcDIjdovB9QMSlrk4nejsWi1noEHzJF_bQ8wsCPWdS-EWmlg', :name => "Ana Manuela", :email => 'anamanuela@gmail.com', :password => 'beef1234', :password_confirmation => 'beef1234'
  league = League.create! name: "Bife com Atum", score_correct: 150, score_difference: 100, score_prediction: 75, owner: league_owner, championships: [Championship.take]
  league.users << league_owner2
  league.users << league_owner
  league.users << (User.create! :image => 'http://fc01.deviantart.net/fs71/i/2010/077/0/3/female_stock_2_by_ralucs_stock.jpg', :name => "Bernardo Silva", :email => 'bernardosilva@gmail.com', :password => 'beef1234', :password_confirmation => 'beef1234')
  league.users << (User.create! :image => 'http://cdn.controlinveste.pt/storage/DN/2012/big/ng1893127.jpg', :name => "Carlos Alexandre", :email => 'carlosalexandre@gmail.com', :password => 'beef1234', :password_confirmation => 'beef1234')

  league2 = League.create! name: "25 de Abril Sempre", score_correct: 200, score_difference: 150, score_prediction: 75, owner: league_owner2, championships: [Championship.take]
  league2.users << league_owner
  league2.users << league_owner2

  puts 'Filling random bets...'
  fdatadb.fill_random_bets league
end