class Championship < ActiveRecord::Base
	has_many :games
	has_many :leagues, through: :league_championships
end
