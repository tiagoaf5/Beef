class BetsController < ApplicationController
  before_action :set_bet, only: [:show, :edit, :update, :destroy]

  # GET /bets
  # GET /bets.json
  def index
    @bets = Bet.all
  end

  # GET /bets/1
  # GET /bets/1.json
  def show
  end

  # GET /bets/new
  def new
    @bet = Bet.new
  end

  # GET /bets/1/edit
  def edit
  end

  # POST /bets
  # POST /bets.json
  def create
    #bet_params_json['user_id'] = current_user.id
    #puts params[:team1goals]
    if current_user
      #bet_params['user_id'] = current_user.id
      #logger.info current_user.id
      @bet= Bet.new(bet_params.merge(:user_id => current_user.id))
    else
      redirect_to new_user_session_path, notice: 'You are not logged in.'
    end
    #logger.info "asd"
    if @bet.save
      render :json => { } # send back any data if necessary
    else
      render :json => { }, :status => 501
    end
  end

  # PATCH/PUT /bets/1
  # PATCH/PUT /bets/1.json
  def update
    respond_to do |format|
      if @bet.update(bet_params)
        format.html { redirect_to @bet, notice: 'Bet was successfully updated.' }
        format.json { render :show, status: :ok, location: @bet }
      else
        format.html { render :edit }
        format.json { render json: @bet.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bets/1
  # DELETE /bets/1.json
  def destroy
    @bet.destroy
    respond_to do |format|
      format.html { redirect_to bets_url, notice: 'Bet was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bet
      @bet = Bet.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def bet_params
      params.require(:bet).permit(:team1_goals, :team2_goals, :score, :user_id, :game_id)
    end

  def bet_params_json
    params.permit(:team1_goals, :team2_goals, :score, :user_id, :game_id)
  end
end
