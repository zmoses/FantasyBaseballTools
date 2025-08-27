module Espn
  class RankingsImporter < BaseImporter
    RANKINGS_URL = "https://www.espn.com/fantasy/baseball/story/_/id/35437997/fantasy-baseball-rankings-points-leagues-2025-espn-cockcroft"

    private

    def table_content
      html_content.css('h2:contains("Top 300 Rankings for 2025")').first.parent.next_element.children.last.children
    end

    def updatable_player(player_node)
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
