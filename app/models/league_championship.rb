class LeagueChampionship < ActiveRecord::Base
  belongs_to :league
  belongs_to :championship
end
