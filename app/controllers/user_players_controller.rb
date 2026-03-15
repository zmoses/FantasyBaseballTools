class UserPlayersController < ApplicationController
  def update_notes
    @user_player = UserPlayer.find_or_create_by(
      user_id: Current.session.user.id,
      player_id: params[:player_id]
    )
    @user_player.update!(notes: params[:notes])

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to draft_board_index_path }
    end
  end
end
