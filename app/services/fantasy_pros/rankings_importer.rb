module FantasyPros
  class RankingsImporter < BaseImporter
    RANKINGS_URL = "https://www.fantasypros.com/mlb/rankings/overall.php"

    private

    def players_list
      # html_content.css('span:contains("Consensus")').first.parent.parent.parent.next_element.css("div.player-row")

      script = html_content.css("script").find { |s| s.text.include?("var ecrData =") }
      match = script.text.match(/var ecrData\s*=\s*(\{.*?\});/m)
      raw_js_object = match[1]
      JSON.parse(raw_js_object)["players"]
    end

    def player_attributes(player_node)
      # In most cases, primary_position is sufficient. For pitchers though,
      # it'll return "P", and we want to specify SP or RP. Similarly, IF if too
      # broad and we want to narrow down to a specific infield position.
      position = player_node["primary_position"]
      position = player_node["player_positions"].split(",").first if position == "P"
      position = (player_node["player_positions"].split(",") - [ "IF" ]).first if position == "IF"

      {
        name: player_node["player_name"],
        fantasy_pros_rank: player_node["rank_ecr"],
        position:
      }
    end
  end
end
