require "net/http"

class BaseImporter < ServiceObject
  def call
    save_players
  end

  private

  def save_players
    players.each do |attrs|
      player = Player.find_best_match(name: attrs[:name], team: attrs[:team], position: attrs[:position])
      next unless player

      rank_field = "#{ranking_type}_rank".to_sym
      player.update_column(rank_field, attrs[rank_field])

      additional_updates(player, attrs)
    end
  end

  def html_content
    @html_content ||= Nokogiri::HTML(Net::HTTP.get(URI(self.class::RANKINGS_URL)))
  end

  def players
    @players ||= table_content.map { |player_row| updatable_player(player_row) }
  end

  def ranking_type
    self.class.module_parent.to_s.downcase
  end

  def additional_updates(player, attrs)
    # Used for overriding in subclasses
  end
end
