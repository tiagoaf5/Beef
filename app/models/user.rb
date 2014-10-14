class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :bets
  has_many :league_users
  has_many :leagues, through: :league_users
  has_many :created_leagues, class_name: "League", foreign_key: "owner_id"
end
