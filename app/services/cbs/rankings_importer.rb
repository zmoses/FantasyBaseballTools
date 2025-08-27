module Cbs
  class RankingsImporter < BaseImporter
    RANKINGS_URL = "https://www.cbssports.com/fantasy/baseball/rankings/h2h/top300/"

    private

    def table_content
      html_content.css('span:contains("Consensus")').first.parent.parent.parent.next_element.css("div.player-row")
    end

    def updatable_player(player_node)
      {
        name: player_node.children[3].children[3].attribute_nodes[0].value.split("/").reject(&:empty?)[-2],
        position: player_node.children[3].text.lines.map(&:strip).reject(&:empty?)[1],
        cbs_rank: player_node.children[1].text.to_i
      }
    end
  end
end
