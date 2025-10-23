class DraftBoardController < ApplicationController
  def index
    @players = Player.where(claimed: false).where.not(espn_rank: nil).order(:espn_rank)
  end
end
