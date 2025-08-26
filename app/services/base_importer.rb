require "net/http"

class BaseImporter < ServiceObject
  def call
    save_players
  end

  private

  def save_players
    position_map = EspnPosition.all.index_by(&:position)
    suspended_players = [ "emmanuelclase" ]
    players.each do |attrs|
      next if suspended_players.include?(attrs[:searchable_name])

      player = Player.find_by(searchable_name: attrs[:searchable_name], team: attrs[:team])
      if player.nil?
        possible_players = Player.where(searchable_name: attrs[:searchable_name])
        if possible_players.count == 1
          player = possible_players.first
        elsif possible_players.count == 0
          binding.pry
        else
          # TODO: Solve this problem more gracefully
          raise "Couldn't uniquely identify player #{attrs[:searchable_name]} (#{possible_players.count} matches)"
        end
      end
      player.update_column(:espn_rank, attrs[:espn_rank])
      player.espn_positions = attrs[:positions].map { |p| position_map[p] }.compact
    end
  end

  def html_content
    @html_content ||= Nokogiri::HTML(Net::HTTP.get(URI(self.class::RANKINGS_URL)))
  end

  def players
    @players ||= table_content.map { |player_row| updatable_player(player_row) }
  end
end
