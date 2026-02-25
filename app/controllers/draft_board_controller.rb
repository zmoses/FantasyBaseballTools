class DraftBoardController < ApplicationController
  def index
    @players = Player
      .left_joins(:player_tracking)
      .where(player_trackings: { claimed: [ nil, false ] })
      .where.not(espn_rank: nil)
      .order(:espn_rank)
  end
end
