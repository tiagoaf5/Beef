class Game < ActiveRecord::Base
  belongs_to :championship
  has_many :bets

  validates :team1_goals, :team2_goals, :matchday,  numericality: { only_integer: true, :greater_than_or_equal_to => -1}

end
