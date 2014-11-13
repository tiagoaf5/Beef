class UsersController < ApplicationController

  def show

    if(user_signed_in?)

      @user=User.find(params[:id])
      @name=@user.name
      @email=@user.email
      @owner=0

      leagues=LeagueUser.where(user_id: params[:id])

      @buddies_leagues=get_buddies(leagues)
      @my_leagues=get_my_leagues(leagues)
      @x=get_score 1

      if current_user.id==params[:id].to_i
        @owner=1

      end
    end
  end

  private

  def get_my_leagues leagues

    my_leagues=Array.new

    leagues.each do |league|
      temp=[]
      temp << league.league_id
      temp << League.find(league.league_id).name
      score = get_score league.league_id
      temp << score[0]
      temp << score[1]
      temp << league.user_score
      my_leagues << temp
    end

    return my_leagues
  end

  def get_score id_league

    users_at_league=LeagueUser.where(league_id: id_league).order("user_score DESC")

    score=Array.new(2)
    score[0]=1
    score[1]= users_at_league.length

    users_at_league.each do |user|
      if user.user_id == params[:id].to_i
        return score
      end
      score[0]=score[0]+1
    end

    return score

  end

  def get_buddies leagues

    leagues_ids=Hash.new

    leagues.each do |league|

      temp_league=LeagueUser.where(league_id: league.league_id)
      temp=Array.new

      temp_league.each do |l|
        temp << l.user_id
      end

      leagues_ids[league.league_id]=temp
    end

    buddies_leagues_ids=Hash.new
    buddies_leagues=Hash.new

    leagues_ids.each do |k, v|
      v.each do |value|

        temp=[]

        if buddies_leagues_ids.has_key?(value)
          if buddies_leagues_ids[value].kind_of?(Array)
            buddies_leagues_ids[value].each do |bv|
              temp << bv
            end
          else
            temp << buddies_leagues_ids[value]
          end
        end

        temp << k
        buddies_leagues_ids[value]=temp
      end
    end

    buddies_leagues_ids.each do |k, v|

      if k!=params[:id].to_i
        user = User.find(k)
        temp_leagues=[]

        v.each do |value|
          temp_leagues << League.find(value).name
        end

        buddies_leagues[user]=temp_leagues
      end
    end

    return buddies_leagues
  end
end
