class LeagueBet < ActiveRecord::Base
  belongs_to :league
  belongs_to :bet
end
