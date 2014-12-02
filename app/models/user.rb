class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  devise :omniauthable, :omniauth_providers => [:facebook]
  after_save :check_pending
  has_many :bets
  has_many :league_users
  has_many :leagues, through: :league_users
  has_many :created_leagues, class_name: "League", foreign_key: "owner_id"

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.name = auth.info.name   # assuming the user model has a name
      user.image = auth.info.image # assuming the user model has an image
    end
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
        user.name = data["name"] if user.name.blank?
        user.image = data["image"] if user.image.blank?
      end
    end
  end

  def check_pending
    if !(@UserTmp = PendingUser.all.find_by_email(self.email)).blank?
      puts 'ola'
      League.find(@UserTmp.leagues_id).users << self
      @UserTmp.destroy
    end
  end



  def update_score league_id, bet_score
    league_user = self.league_users.where(league_id: league_id).first
    league_user.user_score += bet_score
    league_user.save
  end
end
