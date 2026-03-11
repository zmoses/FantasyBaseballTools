require 'net/http'
require 'json'
require 'uri'

module Gemini
  class Requester
    API_KEY = Rails.application.credentials.google_gemini_key

    def self.player_to_draft_next(league:)
      uri = URI('https://generativelanguage.googleapis.com/v1beta/models/gemini-flash-latest:generateContent')

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true

      request = Net::HTTP::Post.new(uri.path)
      request['Content-Type'] = 'application/json'
      request['X-goog-api-key'] = API_KEY

      team_players = league.league_players
        .where(roster_status: "drafted_by_user")
        .includes(:player)
        .map { |p| [ p.player.name, p.player.mlb_team ] }

      top_players = league.league_players
        .where(roster_status: "available")
        .order(Arel.sql("(ranks->>'cbs')::integer ASC NULLS LAST"))
        .includes(:player)
        .limit(100)
        .map { |p| [ p.player.name, p.player.mlb_team ] }

      request.body = JSON.generate({
        contents: [ {
          parts: [
            { text: "The user is in a fantasy baseball #{league.scoring_format} league. They want to draft their next player. Can you recommend them 5 players and give a short explanation why? I want you to consider mostly on projections for the #{Time.now.year} season. I also want you to factor in the strengths and weaknesses of other players on the team (for example, HR or SB potential), not just what positions the player needs to fill are. Their current team looks like: #{team_players}. The next hundred players on the draft board are: #{top_players}." }
          ]
        } ],
        generationConfig: {
          responseMimeType: "application/json",
          responseJsonSchema: {
            type: "object",
            properties: {
              players: {
                type: "array",
                items: {
                  type: "object",
                  properties: {
                    name: { type: "string", description: "Name of the player." },
                    position: { type: "string", description: "The position the player plays in a two-letter format." },
                    reasoning: { type: "string", description: "A short one to two sentence description of why this player was selected." }
                  },
                  required: [ "name", "position", "reasoning" ]
                }
              }
            },
            required: [ "players" ]
          }
        }
      })

      response = http.request(request)
      JSON.parse(response.body)
    end
  end
end
