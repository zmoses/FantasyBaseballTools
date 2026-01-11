require "net/http"

module Mlb
  class Client
    BASE_URL = "https://statsapi.mlb.com/api/v1"

    def self.fetch_40_man_roster(team_id)
      uri = URI("#{BASE_URL}/teams/#{team_id}/roster/40Man")
      response = Net::HTTP.get(uri)
      JSON.parse(response)["roster"]
    end
  end
end
