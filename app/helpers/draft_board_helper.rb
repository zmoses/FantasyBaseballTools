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

  def chevron_down_icon(tailwind_color: "text-slate-700", tailwind_size: "size-5")
    content_tag(:svg, class: "#{tailwind_color} #{tailwind_size}", xmlns: "http://www.w3.org/2000/svg", viewBox: "0 0 20 20", fill: "currentColor", "data-slot": "icon", "aria-hidden": "true") do
      content_tag(:path, nil, "fill-rule": "evenodd", d: "M5.22 8.22a.75.75 0 0 1 1.06 0L10 11.94l3.72-3.72a.75.75 0 1 1 1.06 1.06l-4.25 4.25a.75.75 0 0 1-1.06 0L5.22 9.28a.75.75 0 0 1 0-1.06Z", "clip-rule": "evenodd")
    end
  end
end
