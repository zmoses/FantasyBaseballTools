class BaseRankingsImporter < ServiceObject
  def call
    save_players
  end

  private

  def save_players
    players.each do |attrs|
      begin
        player = Player.find_best_match(name: attrs[:name], team: attrs[:team], position: attrs[:position])
      rescue Player::UnknownPlayerNameError
        next
      end

      rank_field = "#{ranking_type}_rank".to_sym
      player.update_column(rank_field, attrs[rank_field])

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
    raise NotImplementedError, "Subclasses must implement players_list"
  end

  def player_attributes(_)
    raise NotImplementedError, "Subclasses must implement player_attributes"
  end
end
