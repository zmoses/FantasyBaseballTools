module Fantrax
  class RankingsImporter < BaseRankingsImporter
    CATS_RANKINGS_URL = "https://fantraxhq.com/top-300-obp-rankings-for-2026-fantasy-baseball/"
    POINTS_RANKINGS_URL = CATS_RANKINGS_URL

    private

    def players_list
      html_content.css("tr[class^='row-']").drop(1)
    end

    def player_attributes(player_node)
      tds = player_node.css("td")
      {
        fantrax_rank: tds[0].text.strip.to_i,
        name: tds[1].text.strip,
        team: tds[2].text.strip,
        position: tds[3].text.strip
      }
    end
  end
end
