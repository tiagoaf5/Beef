class Bet < ActiveRecord::Base
  belongs_to :user
  belongs_to :game
  belongs_to :league
  # has_many :leagues, through: :league_bets #TODO: a bet has many leagues?

  validates :team1_goals, :team2_goals,  numericality: { only_integer: true, :greater_than_or_equal_to => 0}, :allow_nil => true
  #validates :team1_goals, :team2_goals,  numericality: true

  def update_score team1_goals_game, team2_goals_game
    self.score = calculate_points team1_goals_game, team2_goals_game
    self.save

    self.user.update_score self.league.id, self.score
    BetScoreNotification.notify(self,self.user)
  end

  def calculate_points game_team1_goals, game_team2_goals
    bet_team1_goals = self.team1_goals
    bet_team2_goals = self.team2_goals

    if bet_team1_goals == game_team1_goals and bet_team2_goals == game_team2_goals
      self.league.score_correct
    elsif bet_team1_goals - bet_team2_goals == game_team1_goals - game_team2_goals
      self.league.score_difference
    elsif (bet_team1_goals > bet_team2_goals and game_team1_goals > game_team2_goals) or (bet_team1_goals < bet_team2_goals and game_team1_goals < game_team2_goals)
      self.league.score_prediction
    else
      0
    end
  end
end
