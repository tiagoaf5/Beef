class LeaguesController < ApplicationController
  before_action :list_mine
  before_action :set_league, only: [:show, :edit, :update, :destroy, :scoreboard]

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
    redirect_to(league_scoreboard_path)
  end


  # GET /leagues/new
  def new
    @users = User.all.inject({}) do |result, element|
      result[element[:email]] = element[:id]
      result
    end#mod.map(&:email)
    @users_json = @users.to_json.html_safe
    #@user_ids = User.all.map(&:id)
    # = .select('id', 'name').all#.map(&:name)
    @championships = Championship.all.inject({}) do |result, element|
      result[element[:name]] = element[:id]
      result
    end
    @championships_json = @championships.to_json.html_safe
    #@championships_ids = Championship.all.map(&:id)
    @league = League.new
  end

  # GET /leagues/1/edit
  def edit
  end

  # POST /leagues
  # POST /leagues.json
  def create
    @league = League.new(league_params.merge(:user_id => current_user.id).except(:users, :championships))
    league_params['users'].each  do |f|
      puts f
      @league.users << f
    end

    respond_to do |format|
      if @league.save
        format.html { redirect_to @league, notice: 'League was successfully created.' }
        format.json { render :show, status: :created, location: @league }
      else
        format.html { render :new }
        format.json { render json: @league.errors, status: :unprocessable_entity }
      end
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

end
