class AiRequestController < ApplicationController
  def player_recommendations
    response = Gemini::Requester.player_to_draft_next(league: @current_league)
    render json: JSON.parse(response["candidates"].first["content"]["parts"].first["text"])["players"]
  end
end
