class League < ActiveRecord::Base
  belongs_to :user
  has_many :league_bets
  has_many :league_users
  has_many :league_championships
  has_many :bets
  # has_many :bets, through: :league_bets
  has_many :championships, through: :league_championships
  has_many :users, through: :league_users
  belongs_to :owner, class_name: "User", foreign_key: "owner_id"

  validates :score_correct, :score_difference, :score_prediction,  numericality: { :greater_than_or_equal_to => 0}
end
