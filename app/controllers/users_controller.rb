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

      @buddies_leagues=Hash.new

      leagues_ids.each do |k, v|

        v.each do |value|
          if @buddies_leagues.has_key?(value)
            temp=[]

            if @buddies_leagues[value].kind_of?(Array)
              @buddies_leagues[value].each do |bv|
                temp << bv
              end
            else
              temp << @buddies_leagues[value]
            end
            temp << k
            @buddies_leagues[value]=temp
          else
            @buddies_leagues[value]=k
          end

        end
      end

      if current_user.id==params[:id].to_i
        @owner=1

      end
    end
  end
end
