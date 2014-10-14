# --------> Usar com rake db:reset <------------

require 'json'
fixtures = JSON.parse(File.read("#{Rails.root}/db/fixtures.json"))

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
      bet.update! score: points_for_bet(bet, game, league) if game.team1_goals?
      game.bets << bet
      user.bets << bet
      league.bets << bet
    end
  end
end

save_matchday_to_db(format_json(select_matchday(1, fixtures)))
save_matchday_to_db(format_json_without_goals(select_matchday(2, fixtures)))

puts 'Data do primeiro jogo: ' + Game.all.order(time: :asc).first.time.to_s
puts 'Data do primeiro jogo da segunda jornada: ' + Game.where(matchday: 2).order(time: :asc).first.time.to_s

User.create! :email => 'beef1234@gmail.com', :password => 'beef1234', :password_confirmation => 'beef1234'

league = League.create! name: "Bife com Atum", score_correct: 150, score_difference: 100, score_prediction: 75

premierLeague = Championship.create! :name => 'Premier League', :year => 2014, :country => 'England'
premierLeague.games << Game.all
league.championships << premierLeague

leagueOwner = User.create! :email => 'owner@a.com', :password => 'beef1234', :password_confirmation => 'beef1234'
league.owner = leagueOwner
league.users << league.owner
league.users << (User.create! :email => 'a@a.com', :password => 'beef1234', :password_confirmation => 'beef1234')
league.users << (User.create! :email => 'b@a.com', :password => 'beef1234', :password_confirmation => 'beef1234')
league.users << (User.create! :email => 'c@a.com', :password => 'beef1234', :password_confirmation => 'beef1234')

league.users.each do |user|
  random_bets user, league
end