module D1::SearchHelper
  def render_stat_row(data, stat_name)
    return "<tr>
      <td data-toggle='tooltip' data-placement='right' title='#{data['first']['stats'][stat_name][:statDescription]}'>
        <span>
          #{data['first']['stats'][stat_name][:statName]}
        </span>
      </td>
      <td>
        <div class='row'>
          <div class='col-9'>
            <div class='progress'>
              <div class='progress-bar' style='width: #{data['first']['stats'][stat_name][:value]}%;'>
                &nbsp;#{data['first']['stats'][stat_name][:value]}
              </div>
            </div>
          </div>
          <div class='col-3'>
            <small>#{data['first']['stats'][stat_name][:minimum]}/#{data['first']['stats'][stat_name][:maximum]}</small>
          </div>
        </div>
      </td>
      <td>
        <div class='row'>
          <div class='col-9'>
            <div class='progress'>
              <div class='progress-bar' style='width: #{data['second']['stats'][stat_name][:value]}%;'>
                &nbsp;#{data['second']['stats'][stat_name][:value]}
              </div>
            </div>
          </div>
          <div class='col-3'>
            <small>#{data['second']['stats'][stat_name][:minimum]}/#{data['second']['stats'][stat_name][:maximum]}</small>
          </div>
        </div>
      </td>
      <td>#{stats_diff(data['first']['stats'][stat_name][:value], data['second']['stats'][stat_name][:value])}</td>
    </tr>".html_safe
  end

  def render_magazine_row(data)
    return "<tr>
      <td>
        <span data-toggle='tooltip' data-placement='right' title='#{data['first']['stats']['magazine'][:statDescription]}'>
          #{data['first']['stats']['magazine'][:statName]}
        </span>
      </td>
      <td>
        <div class='row'>
          <div class='col-9'>#{data['first']['stats']['magazine'][:value]}</div>
          <div class='col-3'>
            <small>#{data['first']['stats']['magazine'][:minimum]}/#{data['first']['stats']['magazine'][:maximum]}</small>
          </div>
        </div>
      </td>
      <td>
        <div class='row'>
          <div class='col-9'>#{data['second']['stats']['magazine'][:value]}</div>
          <div class='col-3'>
            <small>#{data['second']['stats']['magazine'][:minimum]}/#{data['second']['stats']['magazine'][:maximum]}</small>
          </div>
        </div>
      </td>
      <td>#{magazine_diff(data['first']['stats']['magazine'][:value], data['second']['stats']['magazine'][:value])}</td>
    </tr>".html_safe
  end

  # Return an IMG tag with the icon of the damage type
  #
  def damage_type(damage)
    return "<img src='https://www.bungie.net/#{damage[:damageIconPath]}' title='#{damage[:damageTypeName]}' class='damage-type-icon' data-toggle='tooltip' data-placement='top'>".html_safe
  end

  # Return a DIV with image and text with the source of the weapon
  #
  def source_type(source)
    return "<div class='source'><img src='https://www.bungie.net/#{source['icon']}' title='#{source['sourceName']}' class='image'><div class='text'><span class='title'>#{source['sourceName']}</span><span class='desc'>#{source['description']}</span></div></div>".html_safe
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
  def magazine_diff(first_weapon_stat, second_weapon_stat)
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
