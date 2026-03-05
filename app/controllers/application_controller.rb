class ApplicationController < ActionController::Base
  include Authentication
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :set_current_league

  def set_current_league
    return unless Current.session

    @current_league ||= Current.session.user.leagues.find_by(id: session[:current_league_id])
  end

  def switch_league
    session[:current_league_id] = params[:league_id].presence
    redirect_back_or_to root_path
  end
end
