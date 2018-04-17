module D2::SearchHelper
  def render_d2_stat_row(data, stat_name)
    return "<div class='row stat-row'>
      <div class='col-2 text-right stat-label' data-toggle='tooltip' data-placement='right' title='#{data['first']['stats'][stat_name][:statDescription]}'>
        #{data['first']['stats'][stat_name][:statName]}
      </div>
      <div class='col'>
        <div class='progress'>
          <div class='progress-bar' style='width: #{data['first']['stats'][stat_name][:value]}%;'>
            #{data['first']['stats'][stat_name][:value]}
          </div>
        </div>
      </div>
      <div class='col'>
        <div class='progress'>
          <div class='progress-bar' style='width: #{data['second']['stats'][stat_name][:value]}%;'>
            #{data['second']['stats'][stat_name][:value]}
          </div>
        </div>
      </div>
      <div class='col-2'>
        #{stats_diff(data['first']['stats'][stat_name][:value], data['second']['stats'][stat_name][:value])}
      </div>
    </div>".html_safe
  end

  def render_d2_plain_stat_row(data, stat_name)
    return "<div class='row stat-row'>
      <div class='col-2 text-right stat-label' data-toggle='tooltip' data-placement='right' title='#{data['first']['stats'][stat_name][:statDescription]}'>
        #{data['first']['stats'][stat_name][:statName]}
      </div>
      <div class='col'>#{data['first']['stats'][stat_name][:value]}</div>
      <div class='col'>#{data['second']['stats'][stat_name][:value]}</div>
      <div class='col-2'>#{plain_diff(data['first']['stats'][stat_name][:value], data['second']['stats'][stat_name][:value])}</div>
    </div>".html_safe
  end

  def render_d2_lore(data)
    if data.blank?
      return "<span class='lore-description'>Not available.</span>".html_safe
    else
      return "<span class='lore-subtitle'>#{data[:subtitle]}</span>
        <span class='lore-description'>#{data[:description].gsub(/\n/, '<br>')}</span>".html_safe
    end
  end

  # Auto-generate diff stacked progress bar
  #
  def stats_diff(first_weapon_stat, second_weapon_stat)
    diff_value = first_weapon_stat - second_weapon_stat

    if diff_value < 0
      second_bar = diff_value * -1;
      html = "<div class='progress'><div class='progress-bar' style='width: #{first_weapon_stat}%'></div><div class='progress-bar upper' style='width: #{second_bar}%'></div></div>"
    elsif diff_value > 0
      second_bar = diff_value;
      html = "<div class='progress'><div class='progress-bar' style='width: #{second_weapon_stat}%'></div><div class='progress-bar down' style='width: #{second_bar}%'></div></div>"
    else
      html = "<div class='progress'><div class='progress-bar' style='width: #{first_weapon_stat}%'></div></div>"
    end

    return html.html_safe
  end

  # Return the difference of the weapons' magazine
  #
  def plain_diff(first_weapon_stat, second_weapon_stat)
    diff_value = first_weapon_stat - second_weapon_stat

    if diff_value < 0
      html = "<span class='upper'>#{second_weapon_stat} ▲</span>"
    elsif diff_value > 0
      html = "<span class='down'>#{second_weapon_stat} ▼</span>"
    else
      html = "#{first_weapon_stat}"
    end

    return html.html_safe
  end
end
