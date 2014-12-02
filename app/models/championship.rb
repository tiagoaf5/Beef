class Championship < ActiveRecord::Base
	has_many :games
  has_many :league_championships
  has_many :leagues, through: :league_championships

  validates :country, inclusion:{in:Carmen::Country.all.map(&:name) << 'Scotland' << 'England' << 'Wales' << 'Ireland'}
end
