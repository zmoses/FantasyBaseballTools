module PlayersHelper
  def player_logo_and_name(player)
    logo = player.team ? image_tag("mlb_logos/#{player.team}.png", size: 30) : "(FA)"
    safe_join([ content_tag(:span, logo, class: "mr-4 inline-block"), player.name ], " ")
  end
end
