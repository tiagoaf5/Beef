class Bet < ActiveRecord::Base
  belongs_to :user
  belongs_to :game
  has_many :leagues, through: :league_bets
end
