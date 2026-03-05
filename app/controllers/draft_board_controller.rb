class DraftBoardController < ApplicationController
  def index
    rank_key = @current_league.platform.downcase
    user_id = Current.session.user.id

    @players = @current_league.league_players
      .joins(:player)
      .joins("LEFT JOIN user_players ON user_players.player_id = players.id AND user_players.user_id = #{user_id.to_i}")
      .where(roster_status: :available)
      .where("league_players.ranks ? :key", key: rank_key)
      .order(Arel.sql("(league_players.ranks ->> '#{rank_key}')::int ASC"))
      .select("league_players.*, players.name, players.mlb_team, user_players.notes")
  end
end
