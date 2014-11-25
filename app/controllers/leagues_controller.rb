class LeaguesController < ApplicationController
  before_action :list_mine
  before_action :set_league, only: [:show, :edit, :update, :destroy, :scoreboard, :leaderboard]
  helper_method :updown
  # GET /leagues
  # GET /leagues.json
  def index
    #@leagues = League.all
   # (@myleagues && @myleagues.size != 0) ? redirect_to(league_path(@myleagues.first.league)) : redirect_to(new_league_path)
    #  @leagues = League.all.includes(:bets)
  end

  # GET /leagues/1
  # GET /leagues/1.json
  def show
    puts league_scoreboard_path
    redirect_to(league_leaderboard_path)
  end


  # GET /leagues/new
  def new
    #@championships = Championship.all.inject({}) do |result, element|
    #  result[element[:name]] = element[:id]
    #  result
    #end
    #@championships_json = @championships.to_json.html_safe
    @championships = Championship.all.map(&:name)
    @league = League.new
  end

  # GET /leagues/1/edit
  def edit
  end

  # POST /leagues
  # POST /leagues.json
  def create
    if !(user_signed_in?)
      respond_to do |format|
        format.html { render :new }
        format.json { render :json => "You are not logged in!", status: :unprocessable_entity }
      end
      return
    end

    @league = League.new(league_params.merge(:user_id => current_user.id).except(:users, :championships))

    @league.owner = current_user
    @league.users << current_user

    if league_params['users'].present?
      league_params['users'].each  do |f|
        if (@UserTmp = User.find_by_email(f)).blank?
          InviteMailer.invite_email(@league.owner, f, @league).deliver
        else
          @league.users << @UserTmp
        end
      end
    end

    if league_params['championships'].present?
      league_params['championships'].each  do |f|
        @league.championships << Championship.find_by_name(f)
      end
    end

    respond_to do |format|
      if @league.save
        format.html { redirect_to @league, notice: 'League was successfully created.' }
        format.json { render :show, status: :created, location: @league }
      else
        format.html { render :new }
        format.json { render json: @league.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  def get_users
      puts '%' + params[:term] + '%'
      @users = User.where('email ILIKE ?', '%' + params[:term] + '%').limit(10)

      respond_to do |format|
        format.html { render json: @users.map(&:email)}
        format.js {}
        format.json {
          render json: @users.map(&:email)
        }
      end
    end

  # PATCH/PUT /leagues/1
  # PATCH/PUT /leagues/1.json
  def update
    respond_to do |format|
      if @league.update(league_params)
        format.html { redirect_to @league, notice: 'League was successfully updated.' }
        format.json { render :show, status: :ok, location: @league }
      else

        format.html { render :edit }
        format.json { render json: @league.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /leagues/1
  # DELETE /leagues/1.json
  def destroy
    @league.destroy
    respond_to do |format|
      format.html { redirect_to leagues_url, notice: 'League was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def leaderboard
    @users = @league.users
    bets = @league.bets

    #League details
    @p1 = @league.score_correct
    @p2 = @league.score_difference
    @p3 = @league.score_prediction

    @data = {}
    @users.each do |user|
      my_bets = bets.where(user_id: user.id)
      n_bets = my_bets.count
      n_p1 = my_bets.where(score: @p1).count
      n_p2 = my_bets.where(score: @p2).count
      n_p3 = my_bets.where(score: @p3).count
      n_p4 = my_bets.where(score: 0).count
      total = my_bets.map { |x| x.score.nil? ? 0 : x.score}.sum

      data1 = {n_bets: n_bets, n_p1: n_p1, n_p2: n_p2, n_p3: n_p3, n_p4: n_p4, total: total}
      @data[user.id] = data1
    end

    @data = @data.sort_by{ |_,v| 0 - v[:total]}

  end

  def scoreboard
    @users = @league.users
    @bets = []
    @score = []

    join = @league.bets
    games = @league.championships.take.games

    @match_days = games.group(:matchday).count.map{|k,v| k}.sort

    @users.each do |u|
      @bets[u.id] = join.where(user_id: u.id).order(:game_id)
      @score[u.id] = []
      # @score[u.id] = [@bets[u.id].sum(:score)]

      @match_days.each do |day|
        @score[u.id] << games.where(matchday: day).map{ |match| match.bets.where(user_id: u.id).sum(:score) }.sum
      end
      @score[u.id] << @bets[u.id].sum(:score)
    end

    @users_order = get_users_score_order @score

  end

  def games
    if League.exists?(id: params[:id])
      @league = League.find(params[:id])
      @championship = @league.championships.first
      games = @league.championships.first.games #.order("time asc")
      @match_days = games.group(:matchday).count.map{|k,v| k}.sort
      @games = Hash.new()

      @match_days.each do |day|
         @games[day] = games.where(matchday: day).order("time asc")
       end

    else
      redirect_to(new_league_path)
      return
    end
    #@league = Leagues.all.first
    if user_signed_in? && @league
      @user_bets = @league.bets.where(user_id: current_user.id)
    else
      @user_bets = nil
    end
  end

  def myleagues
    @myleagues = current_user.leagues
  end

  def mybets
    if League.exists?(id: params[:id])
      @league = League.find(params[:id])
      @championship = @league.championships.first
      games = @league.championships.first.games #.order("time asc")
      @match_days = games.group(:matchday).count.map{|k,v| k}.sort
      @games = Hash.new()

      @match_days.each do |day|
        @games[day] = games.where(matchday: day).order("time asc")
      end

    else
      redirect_to(new_league_path)
      return
    end

    #@league = Leagues.all.first
    if user_signed_in? && @league
      @user_bets = @league.bets.where(user_id: current_user.id)
    else
      @user_bets = nil
    end
  end


  private
  # Use callbacks to share common setup or constraints between actions.
  def set_league
    @league = League.find(params[:id])
  end

# Never trust parameters from the scary internet, only allow the white list through.
  def league_params
    params.require(:league).permit(:name, :score_correct, :score_difference, :score_prediction, :user_id, :users => [], :championships => [])
  end

  def list_mine
    if(user_signed_in?)
      @myleagues = LeagueUser.where(user_id: current_user.id)
    else
      @myleagues = nil
    end
  end

  def get_users_score_order score
    users_order = []
    score.each_with_index do |v, k|
      if v
        users_order << [k, v.last] # order by total
      end
    end

    users_order = users_order.sort_by { |v| 0 - v[1] }
    users_order.map { |v| v[0] }
  end

  def updown league
    usersTop = league.bets.joins(:game).where("games.time < date_trunc('day', current_timestamp)").group("user_id").sum(:score)
    usersTop = usersTop.sort_by { |k, v| v }.reverse
    oldPos = 0;
    usersTop.each{|x|
    if(x.at(0) == current_user.id)
      oldPos = usersTop.index(x)
      break
    end
    }

    nusersTop = league.bets.joins(:game).group("user_id").sum(:score)
    nusersTop = nusersTop.sort_by { |k, v| v }.reverse
    nPos = 0
    nPoints = 0
    nusersTop.each{|x|
      if(x.at(0) == current_user.id)
        nPos = nusersTop.index(x)
        nPoints = x.at(1)
        break
      end
    }

    return [nPos,oldPos - nPos,nPoints,oldPos]

  end

end
