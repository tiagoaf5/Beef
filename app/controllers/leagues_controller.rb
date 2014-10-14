class LeaguesController < ApplicationController
  before_action :list_mine
  before_action :set_league, only: [:show, :edit, :update, :destroy, :scoreboard]

  # GET /leagues
  # GET /leagues.json
  def index
    #@leagues = League.all
    (@myleagues && @myleagues.size != 0) ? redirect_to(league_path(@myleagues.first.league)) : redirect_to(new_league_path)
  #  @leagues = League.all.includes(:bets)
  end

  # GET /leagues/1
  # GET /leagues/1.json
  def show
    redirect_to(league_scoreboard_path)
  end


  # GET /leagues/new
  def new
    @league = League.new
  end

  # GET /leagues/1/edit
  def edit
  end

  # POST /leagues
  # POST /leagues.json
  def create
    @league = League.new(league_params)

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
      @score[u.id] = [@bets[u.id].sum(:score)]

      @match_days.each do |day|
        bets_matchday = games.where(matchday: day).map{ |match| match.bets.where(user_id: u.id).sum(:score) }.sum
        @score[u.id] << bets_matchday
      end

    end


  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_league
      @league = League.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def league_params
      params.require(:league).permit(:name, :score_correct, :score_difference, :score_prediction, :user_id)
    end

    def list_mine
      if(user_signed_in?)
          @myleagues = LeagueUser.where(user_id: current_user.id)
      else
          @myleagues = nil
      end
    end

end
