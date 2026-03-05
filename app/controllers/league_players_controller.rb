class LeaguePlayersController < ApplicationController
  before_action :set_league_player, only: %i[ show edit update destroy ]

  # GET /league_players or /league_players.json
  def index
    @league_players = LeaguePlayer.all
  end

  # GET /league_players/1 or /league_players/1.json
  def show
  end

  # GET /league_players/new
  def new
    @league_player = LeaguePlayer.new
  end

  # GET /league_players/1/edit
  def edit
  end

  # POST /league_players or /league_players.json
  def create
    @league_player = LeaguePlayer.new(league_player_params)

    respond_to do |format|
      if @league_player.save
        format.html { redirect_to @league_player, notice: "League player was successfully created." }
        format.json { render :show, status: :created, location: @league_player }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @league_player.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /league_players/1 or /league_players/1.json
  def update
    respond_to do |format|
      if @league_player.update(league_player_params)
        format.html { redirect_to @league_player, notice: "League player was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @league_player }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @league_player.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /league_players/1 or /league_players/1.json
  def destroy
    @league_player.destroy!

    respond_to do |format|
      format.html { redirect_to league_players_path, notice: "League player was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_league_player
      @league_player = LeaguePlayer.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def league_player_params
      params.fetch(:league_player, {})
    end
end
