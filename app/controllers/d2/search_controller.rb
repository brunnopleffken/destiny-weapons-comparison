class D2::SearchController < ApplicationController
  before_action :random_d2_emblem

  def compare
    # Get parameters
    @first = params[:first_weapon]
    @second = params[:second_weapon]
    @weapon_comparison = {}

    # Get weapons data and stats
    raw_first_weapon_stats = get_from_api(@first)
    raw_second_weapon_stats = get_from_api(@second)
    parse_weapon_stats(raw_first_weapon_stats, 'first')
    parse_weapon_stats(raw_second_weapon_stats, 'second')

    @first_weapon = raw_first_weapon_stats
    @second_weapon = raw_second_weapon_stats

    @title = "#{@weapon_comparison['first']['name']} vs. #{@weapon_comparison['second']['name']} | Destiny Weapons Comparison"
  end

  def autocomplete
    # Check if API key is defined in config/initializers
    raise "The Bungie API key is not defined." if Rails.configuration.destiny_api_key.blank?

    results = []

    query = ActiveRecord::Base.connection
      .exec_query("SELECT json FROM DestinyInventoryItemDefinition
        WHERE json LIKE '%\"name\":\"#{params[:term]}%\"%'
        AND json LIKE '%\"itemType\":3%';")

    query.rows.each do |r|
      results << JSON.parse(r[0])
    end

    render json: results and return
  end

  private

  def calculate_hash(hash)
    hash = hash.to_i

    if (hash & 1 << (32 - 1)) != 0
      return (hash - (1 << 32))
    else
      return hash
    end
  end

  def get_from_api(hash)
    hash = calculate_hash(hash)

    query = ActiveRecord::Base.connection
      .exec_query("SELECT json FROM DestinyInventoryItemDefinition WHERE id = #{hash};")

    return JSON.parse(query.rows[0][0])
  end

  def parse_weapon_stats(raw_data, order)
    @weapon_comparison[order] = {}

    # Dictionary
    attack = '1480404414'
    power_level = '1935470627'
    rounds_per_minute = '4284893193'
    charge = '2961396640'
    impact = '4043523819'
    blast_radius = '3614673599'
    range = '1240592695'
    velocity = '2523465841'
    stability = '155624089'
    reload = '4188031367'
    magazine = '3871231066'
    aim_assist = '1345609583'
    handling = '943549884'
    recoil = '2715839340'
    zoom = '3555269338'
    inventory = '1931675084'

    @weapon_comparison[order]['name'] = raw_data['displayProperties']['name']
    @weapon_comparison[order]['description'] = raw_data['displayProperties']['description']
    @weapon_comparison[order]['icon'] = raw_data['displayProperties']['icon']
    @weapon_comparison[order]['tierTypeName'] = get_tier_type_name(raw_data['inventory']['tierTypeHash'])
    @weapon_comparison[order]['itemTypeName'] = raw_data['itemTypeDisplayName']
    @weapon_comparison[order]['damageTypes'] = get_damage_type_definition(raw_data['defaultDamageTypeHash'])
    @weapon_comparison[order]['lore'] = get_lore_definition(raw_data['loreHash'])

    # Define stats order
    @weapon_comparison[order]['stats'] = {}

    raw_data['stats']['stats'].each do |stat|
      case stat[0]
        when attack then stat_type = 'attack'
        when power_level then stat_type = 'power_level'
        when rounds_per_minute, charge then stat_type = 'rounds_per_minute'
        when impact, blast_radius then stat_type = 'impact'
        when range, velocity then stat_type = 'range'
        when stability then stat_type = 'stability'
        when magazine then stat_type = 'magazine'
        when reload then stat_type = 'reload'
        when aim_assist then stat_type = 'aim_assist'
        when handling then stat_type = 'handling'
        when recoil then stat_type = 'recoil'
        when zoom then stat_type = 'zoom'
        when inventory then stat_type = 'inventory'
      end

      definitions = get_stat_definition(stat[0])

      @weapon_comparison[order]['stats'][stat_type] = {
        :statName => definitions['displayProperties']['name'],
        :statDescription => definitions['displayProperties']['description'],
        :value => raw_data['stats']['stats'][stat[0]]['value'],
        :minimum => stat[1]['minimum'],
        :maximum => stat[1]['maximum']
      }
    end
  end

  def get_tier_type_name(hash)
    hash = calculate_hash(hash)

    query = ActiveRecord::Base.connection
      .exec_query("SELECT json FROM DestinyItemTierTypeDefinition WHERE id = #{hash};")

    return JSON.parse(query.rows[0][0])['displayProperties']['name']
  end

  def get_stat_definition(hash)
    hash = calculate_hash(hash)

    query = ActiveRecord::Base.connection
      .exec_query("SELECT * FROM DestinyStatDefinition WHERE id = '#{hash}';")

    return JSON.parse(query.rows[0][1])
  end

  def get_damage_type_definition(hash)
    hash = calculate_hash(hash)

    query = ActiveRecord::Base.connection
      .exec_query("SELECT * FROM DestinyDamageTypeDefinition WHERE id = '#{hash}';")

    return JSON.parse(query.rows[0][1])['displayProperties']
  end

  def get_lore_definition(hash)
    hash = calculate_hash(hash)

    if hash != 0
      query = ActiveRecord::Base.connection
        .exec_query("SELECT * FROM DestinyLoreDefinition WHERE id = '#{hash}';")
      result = JSON.parse(query.rows[0][1])

      return {
        subtitle: result['subtitle'],
        description: result['displayProperties']['description']
      }
    else
      return {}
    end
  end
end
