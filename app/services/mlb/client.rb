module Mlb
  class Client < ApiClient
    BASE_URL = "https://statsapi.mlb.com/api/v1"

    def self.fetch_40_man_roster(team_id)
      get("#{BASE_URL}/teams/#{team_id}/roster/40Man")["roster"]
    end
  end
end
