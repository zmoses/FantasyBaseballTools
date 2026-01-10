module DraftBoardHelper
  def rank_diff_cell_style(reference_rank, compare_rank)
    return if reference_rank.nil? || compare_rank.nil?

    diff = compare_rank - reference_rank

    # Cap extreme differences to avoid blinding colors
    max_diff = 20.0
    normalized = [ [ diff / max_diff, -1 ].max, 1 ].min

    # Green if negative (better), Red if positive (worse)
    # 120 = green, 0 = red
    hue = normalized.negative? ? 120 : 0

    # Make saturation/intensity scale with magnitude
    saturation = (normalized.abs * 80).round
    lightness = 100 - (normalized.abs * 40).round

    "background-color: hsl(#{hue}, #{saturation}%, #{lightness}%);"
  end
end
