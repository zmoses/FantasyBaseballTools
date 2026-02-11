module PlayersHelper
  def player_logo_name_and_positions(player)
    logo = player.team ? image_tag("mlb_logos/#{player.team}.png", size: 30) : "(FA)"
    positions = player.espn_positions.map(&:position).join(", ")

    safe_join([
      content_tag(:span, logo, class: "mr-4 inline-block align-middle"),
      content_tag(:span, player.name, class: "font-semibold"),
      content_tag(:span, positions, class: "italic ml-2")
    ], " ")
  end
end
