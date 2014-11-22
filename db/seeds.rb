# --------> Usar com rake db:reset <------------

require "#{Rails.root}/football_data.rb"

def select_matchday matchday, fixtures
  fixtures.select do |fixture|
    fixture['matchday'] == matchday
  end
end

def format_json matchday
  matchday.map do |fixture|
    {
        team1_name: fixture['homeTeam'],
        team2_name: fixture['awayTeam'],
        team1_goals: fixture['goalsHomeTeam'],
        team2_goals: fixture['goalsAwayTeam'],
        time: fixture['date'],
        matchday: fixture['matchday']
    }
  end
end

def format_json_without_goals matchday
  format_json(matchday).map do |fixture|
    fixture.except(:team1_goals, :team2_goals)
  end
end

def save_matchday_to_db matchday
  matchday.each do |fixture|
    Game.create! fixture
  end
end

def points_for_bet bet, game, league
  bet_team1_goals = bet.team1_goals
  bet_team2_goals = bet.team2_goals
  game_team1_goals = game.team1_goals
  game_team2_goals = game.team2_goals

  if bet_team1_goals == game_team1_goals and bet_team2_goals == game_team2_goals
    league.score_correct
  elsif bet_team1_goals - bet_team2_goals == game_team1_goals - game_team2_goals
    league.score_difference
  elsif (bet_team1_goals > bet_team2_goals and game_team1_goals > game_team2_goals) or (bet_team1_goals < bet_team2_goals and game_team1_goals < game_team2_goals)
    league.score_prediction
  else
    0
  end
end

def random_bets user, league
  league.championships.each do |championship|
    championship.games.each do |game|
      bet = Bet.create! team1_goals: rand(4), team2_goals: rand(4)
      bet.update! score: points_for_bet(bet, game, league) if game.team1_goals.nil?
      game.bets << bet
      user.bets << bet
      league.bets << bet
    end
  end
end

def save_matches_to_db matches
  saved_matches = []

  matches.each do |match|
    saved_matches.push( Game.create! match )
  end

  saved_matches
end

def save_leagues_to_db leagues
  leagues.each do |league|
    puts "Saving #{league[:league_name]}"
    saved_league = Championship.create! :name => league[:league_name], :year => league[:year], :country => league[:country]

    saved_matches = save_matches_to_db(league[:matches])
    saved_matches.each { |saved_match| saved_league.games << saved_match }
  end
end

puts 'Saving fixtures to database...'
fdata = FootballData.new
fdata.load_all_fixtures
save_leagues_to_db fdata.fixtures

puts "First game: #{Game.all.order(time: :asc).first.time.to_s}"
puts "Last game: #{Game.all.order(time: :asc).last.time.to_s}"
puts "Last updated: #{Game.where.not(team1_goals: -1).order(:time).last.time}"
puts "Next update: #{Game.where(team1_goals: -1).order(:time).first.time}"

User.create! :email => 'beef1234@gmail.com', :password => 'beef1234', :password_confirmation => 'beef1234'

puts 'Creating league and adding users...'
leagueOwner = User.create! :email => 'owner@a.com', :password => 'beef1234', :password_confirmation => 'beef1234'
league = League.create! name: "Bife com Atum", score_correct: 150, score_difference: 100, score_prediction: 75, owner: leagueOwner, championships: [Championship.take]

# league.championships << Championship.take
# league.owner = leagueOwner
league.users << league.owner
league.users << (User.create! :email => 'a@a.com', :password => 'beef1234', :password_confirmation => 'beef1234')
league.users << (User.create! :email => 'b@a.com', :password => 'beef1234', :password_confirmation => 'beef1234')
league.users << (User.create! :email => 'c@a.com', :password => 'beef1234', :password_confirmation => 'beef1234')

puts 'Filling random bets...'
league.users.each do |user|
  random_bets user, league
end

=begin

# Seeding the old way, without internet access/cache

fixtures = JSON.parse(File.read("#{Rails.root}/db/fixtures.json"))

save_matchday_to_db(format_json(select_matchday(1, fixtures)))
save_matchday_to_db(format_json_without_goals(select_matchday(2, fixtures)))

premierLeague = Championship.create! :name => 'Premier League', :year => 2014, :country => 'England'
premierLeague.games << Game.all
league.championships << premierLeague

def select_matchday matchday, fixtures
  fixtures.select do |fixture|
    fixture['matchday'] == matchday
  end
end

def format_json matchday
  matchday.map do |fixture|
    {
        team1_name: fixture['homeTeam'],
        team2_name: fixture['awayTeam'],
        team1_goals: fixture['goalsHomeTeam'],
        team2_goals: fixture['goalsAwayTeam'],
        time: fixture['date'],
        matchday: fixture['matchday']
    }
  end
end

def format_json_without_goals matchday
  format_json(matchday).map do |fixture|
    fixture.except(:team1_goals, :team2_goals)
  end
end

=end