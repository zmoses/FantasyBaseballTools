json.extract! player, :id, :name, :espn_rank, :cbs_rank, :fantasy_pros_rank, :team, :created_at, :updated_at
json.url player_url(player, format: :json)
