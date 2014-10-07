class Game < ActiveRecord::Base
  belongs_to :championship
  has_many :bets
end
