module ApplicationHelper

  # Return an IMG tag with the icon of the damage type
  #
  def damage_type(damage)
    html = "<img src='https://www.bungie.net/#{damage[:damageIconPath]}' title='#{damage[:damageTypeName]}' class='damage-type-icon'>"
    return html.html_safe
  end

  # Return a DIV with image and text with the source of the weapon
  #
  def source_type(source)
    html = ""
    unless source.nil?
      html = "<div class='source'><img src='https://www.bungie.net/#{source[:sourceIcon]}' title='#{source[:sourceName]}' class='image'><div class='text'><span class='title'>#{source[:sourceName]}</span><span class='desc'>#{source[:sourceDesc]}</span></div></div>"
    end
    return html.html_safe
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
