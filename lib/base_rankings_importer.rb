class BaseRankingsImporter < ServiceObject
  def call(league)
    @league = league
    save_players
  end

  private

  def save_players
    players.each do |attrs|
      begin
        player = Player.find_best_match(name: attrs[:name], mlb_team: attrs[:team], position: attrs[:position])
      rescue Player::UnknownPlayerNameError
        next
      end

      league_player = LeaguePlayer.find_or_initialize_by(league_id: @league.id, player_id: player.id)
      league_player.ranks = (league_player.ranks || {}).merge(ranking_type => attrs["#{ranking_type}_rank".to_sym])
      league_player.ranks_synced_at = Time.now
      league_player.save!

      additional_updates(player, attrs)
    end
  end

  def html_content
    @html_content ||= Nokogiri::HTML(Net::HTTP.get(URI(self.class::RANKINGS_URL)))
  end

  def players
    @players ||= players_list.map { |player_row| player_attributes(player_row) }
  end

  def ranking_type
    self.class.module_parent.to_s.underscore
  end

  def additional_updates(player, attrs)
    # Used for overriding in subclasses, but not required
  end

  def players_list
    # Return value should be an array of players that are gathered from the importer source in any
    # format. These players will be formatted consistently for use with #player_attributes further
    # in the chain of calls.
    raise NotImplementedError, "Subclasses must implement players_list"
  end

  def player_attributes(_)
    # This handles formatting each individual player's data in a standard format:
    # {
    #   name:
    #   position:
    #   xyz_rank:
    # }
    # Note, for "xyz_rank", "xyz" must match the module each rankings_importer lives in.
    raise NotImplementedError, "Subclasses must implement player_attributes"
  end
end
