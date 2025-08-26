require "net/http"

class BaseImporter < ServiceObject
  def call
    add_players_from_rows
    binding.pry
  end

  private

  def save_players
  end

  def html_content
    @html_content ||= Nokogiri::HTML(Net::HTTP.get(URI(self.class::RANKINGS_URL)))
  end

  def add_players_from_rows
    @players ||= table_content.map { |player_row| updatable_player(player_row) }
  end
end
