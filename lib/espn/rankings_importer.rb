require "espn_api"

module Espn
  class RankingsImporter < BaseRankingsImporter
    RANKINGS_URL = "https://www.espn.com/fantasy/baseball/story/_/id/35437997/fantasy-baseball-rankings-points-leagues-2026-espn-cockcroft"

    def espn_client
      @client ||= ESPNApi::Client.new(
        auth_key: ENV["ESPN_KEY"],
        league_id: ENV["LEAGUE_ID"]
      )
    end

    def api_filters
      @filters ||= ESPNApi::Filters::Player.new.limit(600)
    end

    private

    def players_list
      # Grabbing via API enables a larger list to be returned, try that and fallback to scraping
      api_players = espn_client.players_list(player_filters: api_filters)
      return api_players if api_players

      html_content.css('h2:contains("Top 300 Rankings for")').first.parent.next_element.children.last.children
    end

    def player_attributes(player_node)
      {
        name: player_node.children[2].text,
        team: player_node.children[3].text,
        espn_rank: player_node.children.first.text.to_i,
        eligible_positions: player_node.children[4].text.split("/")
      }
    end

    def position_map
      @position_map ||= EspnPosition.all.index_by(&:position)
    end

    def additional_updates(player, attrs)
      player.espn_positions = attrs[:eligible_positions].map { |p| position_map[p] }.compact
    end
  end
end
