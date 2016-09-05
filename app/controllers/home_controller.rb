class HomeController < ApplicationController

  def index
    @title = 'Destiny Weapons Comparison'
    @description = 'Compare Destiny weapons stats! Rate of fire, range, stability, but also compare useful hidden stats like aim assistance and recoil.'
    @language = 'en'
  end

  def compare
    # Get parameters
    @first = params[:first_weapon]
    @second = params[:second_weapon]
    @language = params[:lang]

    @weapon_comparison = {}

    # Check if user is trying to compare Y1 with Y2 weapon
    if @first == @second
      first_weapon_direction = 'Ascending'
      second_weapon_direction = 'Descending'
    else
      first_weapon_direction = second_weapon_direction = 'Descending'
    end

    # Get weapons data and stats
    raw_first_weapon_stats = get_from_api(@first, first_weapon_direction)
    raw_second_weapon_stats = get_from_api(@second, second_weapon_direction)

    # Checks if the search doesn't return empty
    if raw_first_weapon_stats['Response']['data']['itemHashes'].empty?
      @keyword = @first
      render :is_empty_error and return
    elsif raw_second_weapon_stats['Response']['data']['itemHashes'].empty?
      @keyword = @second
      render :is_empty_error and return
    end

    parse_weapon_stats(raw_first_weapon_stats['Response'], 'first')
    parse_weapon_stats(raw_second_weapon_stats['Response'], 'second')

    @title = "DWC | #{@weapon_comparison['first']['itemName']} vs. #{@weapon_comparison['second']['itemName']}"
    @description = "Destiny Weapons Comparison - #{@weapon_comparison['first']['itemName']} vs. #{@weapon_comparison['second']['itemName']}"
  end

  private

  def get_from_api(weapon_name, direction)
    # Check if API key is defined in config/initializers
    raise "The Bungie API key is not defined." if Rails.configuration.destiny_api_key == ''

    # Define basic parameters
    source = URI('https://www.bungie.net/Platform/Destiny/Explorer/Items/')
    parameters = {
      :definitions => true,
      :lc => @language,
      :name => weapon_name,
      :order => 'MaximumRequiredLevel',
      :direction => direction
    }

    # Create new HTTP request
    source.query = URI.encode_www_form(parameters)
    request = Net::HTTP::Get.new(source)
    request['X-Api-Key'] = Rails.configuration.destiny_api_key

    # Get response
    response = Net::HTTP.start(source.hostname, source.port, :use_ssl => source.scheme == 'https') do |http|
      http.request(request)
    end

    return JSON.parse(response.body)
  end

  # ------------------

  def parse_weapon_stats(raw_data, order)
    @weapon_comparison[order] = {}
    item_hash = raw_data['data']['itemHashes'].first.to_s

    validate_results(raw_data, item_hash)

    # Dictionary
    attack = '368428387'
    light_level = '2391494160'
    rate_of_fire = '4284893193'
    charge = '2961396640'
    impact = '4043523819'
    blast_radius = '3614673599'
    range = '1240592695'
    velocity = '2523465841'
    stability = '155624089'
    reload = '4188031367'
    magazine = '3871231066'
    aim_assist = '1345609583'
    equip_speed = '943549884'
    recoil = '2715839340'
    zoom = '3555269338'

    @weapon_comparison[order]['itemName'] = raw_data['definitions']['items'][item_hash]['itemName']
    @weapon_comparison[order]['itemDescription'] = raw_data['definitions']['items'][item_hash]['itemDescription']
    @weapon_comparison[order]['icon'] = raw_data['definitions']['items'][item_hash]['icon']
    @weapon_comparison[order]['tierType'] = raw_data['definitions']['items'][item_hash]['tierType']
    @weapon_comparison[order]['tierTypeName'] = raw_data['definitions']['items'][item_hash]['tierTypeName']
    @weapon_comparison[order]['itemTypeName'] = raw_data['definitions']['items'][item_hash]['itemTypeName']
    @weapon_comparison[order]['damageTypes'] = []
    @weapon_comparison[order]['sources'] = []

    # Define stats order
    @weapon_comparison[order]['stats'] = {}

    raw_data['definitions']['items'][item_hash]['stats'].each do |stat|
      case stat[0]
        when attack then stat_type = 'attack'
        when light_level then stat_type = 'light_level'
        when rate_of_fire, charge then stat_type = 'rate_of_fire'
        when impact, blast_radius then stat_type = 'impact'
        when range, velocity then stat_type = 'range'
        when stability then stat_type = 'stability'
        when magazine then stat_type = 'magazine'
        when reload then stat_type = 'reload'
        when rate_of_fire then stat_type = 'rate_of_fire'
        when aim_assist then stat_type = 'aim_assist'
        when equip_speed then stat_type = 'equip_speed'
        when recoil then stat_type = 'recoil'
        when zoom then stat_type = 'zoom'
      end

      @weapon_comparison[order]['stats'][stat_type] = {
        :statName => raw_data['definitions']['stats'][stat[0]]['statName'],
        :statDescription => raw_data['definitions']['stats'][stat[0]]['statDescription'],
        :value => raw_data['definitions']['items'][item_hash]['stats'][stat[0]]['value'],
        :minimum => raw_data['definitions']['items'][item_hash]['stats'][stat[0]]['minimum'],
        :maximum => raw_data['definitions']['items'][item_hash]['stats'][stat[0]]['maximum']
      }
    end

    raw_data['definitions']['sources'].each do |source|
      @weapon_comparison[order]['sources'] << source[1]
    end

    raw_data['definitions']['damageTypes'].each do |damage|
      @weapon_comparison[order]['damageTypes'] << {
        :damageTypeName => damage[1]['damageTypeName'],
        :damageIconPath => damage[1]['iconPath']
      }
    end
  end

  # ------------------

  def validate_results(raw_data, item_hash)
    if raw_data['definitions']['items'][item_hash]['itemType'] != 3
      @found_item_name = raw_data['definitions']['items'][item_hash]['itemName']
      @found_item_type = raw_data['definitions']['items'][item_hash]['itemTypeName']
      render :is_armor_error and return
    end
  end

end
