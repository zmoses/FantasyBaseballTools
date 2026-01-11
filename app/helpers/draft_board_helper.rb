module DraftBoardHelper
  def rank_diff_cell_style(reference_rank, compare_rank)
    # If they match or if one doesn't exist, we don't need to adjust background color.
    return if reference_rank.nil? || compare_rank.nil?
    return if reference_rank == compare_rank

    diff = compare_rank - reference_rank

    # Cap extreme differences to avoid overly intense colors
    max_diff = 40.0
    normalized = [ [ diff / max_diff, -1 ].max, 1 ].min

    # Green if negative (better), red if positive (worse)
    # 120 = green, 0 = red
    hue = normalized.negative? ? 120 : 0

    # Saturation scales from 15% (small difference) to 70% (max difference). The further from
    # reference, the more saturation there is.
    saturation = (15 + (normalized.abs * 55)).round

    # Lightness scales from 30% (small difference) to 50% (max difference). The further from
    # reference, the lighter the color is.
    lightness = 30 + (normalized.abs * 20).round

    "background-color: hsl(#{hue}, #{saturation}%, #{lightness}%);"
  end
end
