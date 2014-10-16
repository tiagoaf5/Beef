class Bet < ActiveRecord::Base
  belongs_to :user
  belongs_to :game
  belongs_to :league
  # has_many :leagues, through: :league_bets #TODO: a bet has many leagues?

  validates :team1_goals, :team2_goals,  numericality: { only_integer: true, :greater_than_or_equal_to => 0}
end
