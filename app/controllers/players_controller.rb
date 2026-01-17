class PlayersController < ApplicationController
  before_action :set_player, only: :show

  # GET /players/1 or /players/1.json
  def show
  end

  def claim
    @player = Player.find(params[:id])
    @player.update(claimed: true)

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to players_path, notice: "Player claimed." }
    end
  end

  def mark_all_unclaimed
    Player.update_all(claimed: false)
    redirect_to draft_board_index_path
  end

  def reset_all
    ResetPlayersTableJob.perform_later

    redirect_to players_path, notice: "Player data reset has started. Please refresh this page in a few minutes to see updated rankings.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_player
      @player = Player.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def player_params
      params.expect(player: [ :name, :espn_rank, :cbs_rank, :fantasy_pros_rank, :team ])
    end
end
