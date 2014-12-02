class FootballDataDB
  attr_accessor :football_data

  def initialize football_data
    @football_data = football_data
  end

  def save_leagues_to_db
    @football_data.fixtures.each do |league|
      puts "Saving #{league[:league_name]}"
      saved_league = Championship.create! :name => league[:league_name], :year => league[:year], :country => league[:country]

      saved_matches = create_matches_to_db league[:matches]
      saved_matches.each { |saved_match| saved_league.games << saved_match }
    end
  end

  def fill_random_bets league
    league.users.each do |user|
      random_bets user, league
    end
  end

  def update_database
    @football_data.download_all_fixtures

    save_matches_to_db
  end

  private

  def create_matches_to_db matches
    saved_matches = []

    matches.each do |match|
      saved_matches.push(Game.create! match)
    end

    saved_matches
  end

  def save_matches_to_db
    @football_data.fixtures.each do |league|
      league.each do |match|
        Game.where({team1_name: match[:team1_name], team2_name: match[team2_name],
                    time: match[:time]})
            .update_all({team1_goals: match[:team1_goals],
                         team2_goals: match[:team2_goals]})
      end
    end
  end

  def random_bets user, league
    league.championships.each do |championship|
      championship.games.each do |game|
        bet = Bet.create! team1_goals: rand(4), team2_goals: rand(4)
        # bet.update! score: points_for_bet(bet, game, league) if game.team1_goals.nil?
        game.bets << bet
        user.bets << bet
        league.bets << bet

        # force score updates
        game.save
      end
    end
  end

end