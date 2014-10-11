class Bet < ActiveRecord::Base
  belongs_to :user
  belongs_to :game
  belongs_to :league
  # has_many :leagues, through: :league_bets #TODO: a bet has many leagues?
end
