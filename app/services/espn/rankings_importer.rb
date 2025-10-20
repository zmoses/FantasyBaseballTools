module Espn
  class RankingsImporter < BaseImporter
    # This only grabs the top 300 players, and you can draft way beyond that,
    # usually ending up with some players other sites rank way higher. Might
    # need to change this to grabbing via an API later for deeper rankings. The
    # ESPN Fantasy API exists, but is not publicly documented and is a separate
    # effort I've been working on. Once implemented, I'll work to bring that in

    RANKINGS_URL = "https://www.espn.com/fantasy/baseball/story/_/id/35437997/fantasy-baseball-rankings-points-leagues-2025-espn-cockcroft"

    private

    def players_list
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
