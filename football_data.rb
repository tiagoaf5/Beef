class FootballData
  include HTTParty

  base_uri 'http://www.football-data.org'
  attr_accessor :excluded_countries
  attr_accessor :excluded_league_names
  attr_reader :fixtures
  attr_reader :newest_to_update

  def initialize
    @cache_filename = 'api_data_cache.json'
    @excluded_countries = []
    @excluded_league_names = []
  end

  def load_all_fixtures
    puts "Searching for #{@cache_filename}..."

    if File.exist? @cache_filename and File.mtime('api_data_cache.json') + 1.day >= Time.now
      puts '...found!'

      read_from_cache
    else
      puts '...Not detected or outdated, re-downloading matches'

      download_all_fixtures
    end
  end

  def download_all_fixtures
    ids = league_ids

    @fixtures = ids.map do |id|
      fixtures_by_league id
    end if not ids.nil?

    remove_excluded_countries!
    remove_excluded_league_names!
   #add_outdated_leagues_to_excluded!
    find_newest_to_update

    puts "Next to be updated: #{@newest_to_update}"

    fixtures_to_file @cache_filename
  end

  def next_update_time
    find_newest_to_update
    @newest_to_update[:time]
  end

  private
  def remove_excluded_countries!
    @fixtures.select! { |fixture| @excluded_countries.index( fixture[:country] ).nil? }
  end

  def remove_excluded_league_names!
    @fixtures.select! { |fixture| @excluded_league_names.index( fixture[:league_name] ).nil? }
  end

  def add_outdated_leagues_to_excluded!
    find_newest_to_update

    if @newest_to_update[:time] < DateTime.now
      puts "Removing outdated: #{@newest_to_update[:league_name]} because #{@newest_to_update} is a past game and has no result"

      @excluded_league_names << @newest_to_update[:league_name]
      remove_excluded_league_names!

      add_outdated_leagues_to_excluded!
    end
  end

  def find_newest_to_update
    @newest_to_update = nil
    newest_league_name = nil

    @fixtures.each do |fixture|
      fixture[:matches].select { |match| match[:time] >= DateTime.now }.each do |match|
        if match[:team1_goals] == -1
          if @newest_to_update.nil?
            @newest_to_update = match.dup
            newest_league_name = fixture[:league_name]
          else
            if @newest_to_update[:time] > match[:time]
              @newest_to_update = match.dup
              newest_league_name = fixture[:league_name]
            end
          end
        end
      end
    end

    @newest_to_update[:league_name] = newest_league_name
    @newest_to_update
  end

  def read_from_cache
    @fixtures = JSON.parse(File.read @cache_filename).map do |season|
      season.deep_symbolize_keys!
    end

    remove_excluded_countries!
    remove_excluded_league_names!
    #add_outdated_leagues_to_excluded!
  end

  def country_of_league league
    if league.include? 'Bundesliga'
      'Germany'
    elsif league.include? 'Serie'
      'Italy'
    elsif league.include? 'Division'
      'Spain'
    elsif league.include? 'Ligue'
      'France'
    elsif league.include? 'Premier'
      'United Kingdom'
    else
      'Netherlands'
    end
  end

  def league_ids
    response = self.class.get('/soccerseasons')

    return nil if response.code != 200

    JSON.parse(response.body).select do |season|
      current_season = DateTime.now.year
      current_season += 1 if DateTime.now.month < 8

      season['year'].to_i == current_season
    end.map { |season| {id: season['id'], league_name: season['caption'], year: season['year']} }
  end

  def fixtures_by_league id
    response = self.class.get("/soccerseasons/#{id[:id]}/fixtures")

    return nil if response.code != 200

    puts "Parsing league #{id[:league_name]}"

    {
        league_name: id[:league_name],
        year: id[:year],
        country: country_of_league(id[:league_name]),
        league_api_id: id[:id],
        matches: JSON.parse(response.body).map do |fixture|
          {
              team1_name: fixture['homeTeam'],
              team2_name: fixture['awayTeam'],
              team1_goals: fixture['goalsHomeTeam'].to_i,
              team2_goals: fixture['goalsAwayTeam'].to_i,
              time: fixture['date'],
              matchday: fixture['matchday']
          }
        end
    }
  end

  def fixtures_to_file filename
    return if @fixtures.nil?

    puts "Saving file #{filename}..."

    File.open(filename, 'w') do |f|
      f.write(JSON.pretty_generate @fixtures)
    end
  end
end