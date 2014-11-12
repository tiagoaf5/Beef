class UsersController < ApplicationController

  def show

    if(user_signed_in?)

      @user=User.find(params[:id])
      @name=@user.name
      @email=@user.email
      @owner=0

      leagues=LeagueUser.where(user_id: params[:id])
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
      @buddies_leagues=Hash.new

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

          @buddies_leagues[user]=temp_leagues
        end
      end

      if current_user.id==params[:id].to_i
        @owner=1

      end
    end
  end
end
