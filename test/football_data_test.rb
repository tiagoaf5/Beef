require 'test_helper'
require "#{Rails.root}/football_data.rb"
require "#{Rails.root}/football_data_db.rb"


class BetTest < ActiveSupport::TestCase
  def setup
    @fdata = FootballData.new
    @fdata.cache_filename = 'mock_data1.json'
    @fdata.load_all_fixtures
  end

  test 'correct number of leagues' do
    assert_equal 11, @fdata.fixtures.size
  end

  test 'correct league info' do
    tested_league = @fdata.fixtures[0]
    assert_equal ['1. Bundesliga 2014/15', 'Germany', '2014'], [tested_league[:league_name], tested_league[:country], tested_league[:year]]
  end

  test 'correct nr matches' do
    assert_equal 306, @fdata.fixtures[0][:matches].size
  end

  test 'correct match info' do
    tested_match = @fdata.fixtures[0][:matches][0]
    assert_equal ['FC Bayern München', 'VfL Wolfsburg', 2, 1, '2014-08-22T18:30:00Z', 1], [tested_match[:team1_name], tested_match[:team2_name], tested_match[:team1_goals], tested_match[:team2_goals], tested_match[:time], tested_match[:matchday]]
  end

  test 'get data from API' do
    @fdata.download_all_fixtures
    assert_equal 11, @fdata.fixtures.size
  end
end
