class League < ActiveRecord::Base
  belongs_to :user
  has_many :bets, through: :league_bets
  has_many :championships, through: :league_championships
  has_many :users, through: :league_users
  has_one :owner, class_name: "User", foreign_key: "owner_id"
end