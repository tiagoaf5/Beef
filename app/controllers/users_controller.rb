class UsersController < ApplicationController

  def show

    if(user_signed_in?)

      @user=User.find(params[:id])
      @name=@user.name
      @email=@user.email
      @owner=0
      @friend=0

      leagues=LeagueUser.where(user_id: params[:id])
      @buddies_leagues=get_buddies(leagues)
      @my_leagues=get_my_leagues(leagues)
      @stats=get_stats(leagues)


      if current_user.id==params[:id].to_i
        @owner=1

      else if @buddies_leagues.has_key?(User.find(current_user.id))

            @friend=1
            temp=LeagueUser.where(user_id: current_user.id)
            @buddy_leagues=Array.new
            intersection=Array.new
            @my_leagues_intersection=Array.new

            temp.each do |v|
              @buddy_leagues << v.league_id
            end

            leagues.each do |league|
              if(@buddy_leagues.include?(league.league_id))
                intersection << league
              end
            end
            
            if intersection.length>0
              @my_leagues_intersection=get_my_leagues(intersection)
            end
          end
      end

    end
  end

  private

  def get_stats leagues

    my_stats=Hash.new

    leagues.each do |league|
      league_complete=League.find(league.league_id)
      won=league_complete.score_correct
      prediction=league_complete.score_prediction
      difference=league_complete.score_difference

      bets=Bet.where("user_id = ? AND league_id = ?", params[:id], league.league_id)
      my_stats["size"]=bets.count
      my_stats["won"]=bets.where("score=? ", won).count
      my_stats["prediction"]=bets.where("score=? ", prediction).count
      my_stats["difference"]=bets.where("score=? ", difference).count
      my_stats["lost"]=bets.where("score=? ", 0).count
    end

    return my_stats
  end

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
          aux=[]
          aux << value
          aux << League.find(value).name
          temp_leagues << aux
        end

        buddies_leagues[user]=temp_leagues
      end
    end

    return buddies_leagues
  end
end
