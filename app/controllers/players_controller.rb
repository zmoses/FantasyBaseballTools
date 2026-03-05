class PlayersController < ApplicationController
  before_action :set_player, only: :show

  # GET /players/1 or /players/1.json
  def show
  end

  def claim
    @player = Player.find(params[:id])
    tracking = @player.player_tracking || @player.build_player_tracking
    tracking.update!(claimed: true)

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to players_path, notice: "Player claimed." }
    end
  end

  def mark_all_unclaimed
    PlayerTracking.update_all(claimed: false)
    redirect_to draft_board_index_path
  end

  def update_notes
    @player = Player.find(params[:id])
    tracking = @player.player_tracking || @player.build_player_tracking
    tracking.update!(notes: params[:notes])

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to draft_board_index_path }
    end
  end

  def reset_all
    ResetPlayersTableJob.perform_later

    redirect_to players_path, notice: "Player data reset has started. Please refresh this page in a few minutes to see updated rankings.", status: :see_other
  end

  def sync_all
    SyncPlayersJob.perform_now(league: @current_league)

    redirect_to draft_board_index_path, notice: "Player sync has started. Players not on any 40-man roster will be marked as free agents. Please refresh in a few minutes.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_player
      @player = Player.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def player_params
      params.expect(player: [ :name, :mlb_team ])
    end
end
