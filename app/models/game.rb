class Game < ActiveRecord::Base
  belongs_to :championship
  has_many :bets


  validates :team1_goals, :team2_goals, :matchday,  numericality: { only_integer: true, :greater_than_or_equal_to => -1}
  after_save :update_bet_scores

  def update_bet_scores
    if !self.team1_goals.nil? and !self.team2_goals.nil?
      self.bets.each do |bet|
        bet.update_score self.team1_goals, self.team2_goals
      end
    end
  end
end