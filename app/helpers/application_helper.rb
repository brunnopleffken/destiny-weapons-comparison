module ApplicationHelper

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

  def magazine_diff(first_weapon_stat, second_weapon_stat)
    diff_value = first_weapon_stat - second_weapon_stat

    if diff_value < 0
      html = "<span class='upper'>#{second_weapon_stat} ▲</span>"
    elsif diff_value > 0
      html = "<span class='down'>#{second_weapon_stat} ▼</span>"
    else
      html = ""
    end

    return html.html_safe
  end

end
