module Mlb
  class Client < BaseClient
    def self.fetch_40_man_roster(team_id)
      get("/teams/#{team_id}/roster/40Man")["roster"]
    end

    private

    def base_url
      "https://statsapi.mlb.com/api/v1"
    end
  end
end
