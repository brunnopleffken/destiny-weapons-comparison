class HomeController < ApplicationController

  def index
    #
  end

  def compare
    # Get parameters
    @primary_weapon = params[:primary]
    @secondary_weapon = params[:secondary]

    # Definitions
    @damage_types = {}
    @source_types = {}

    # Get weapons data and stats
    @primary = parse_weapon_stats(get_weapon_stats(@primary_weapon))
    @secondary = parse_weapon_stats(get_weapon_stats(@secondary_weapon))

    # Dictionary
    @attack = '368428387'
    @light_level = '2391494160'
    @rate_of_fire = '4284893193'
    @impact = '4043523819'
    @range = '1240592695'
    @stability = '155624089'
    @reload = '4188031367'
    @magazine = '3871231066'
    @aim_assist = '1345609583'
    @equip_speed = '943549884'
    @recoil = '2715839340'
    @zoom = '3555269338'
  end

  private

  def get_weapon_stats(weapon_name)
    # Check if API key is defined in config/initializers
    raise "The Bungie API key is not defined." if Rails.configuration.destiny_api_key == ''

    # Define basic parameters
    source = URI('https://www.bungie.net/Platform/Destiny/Explorer/Items/')
    parameters = { :definitions => true, :lc => 'pt-br', :name => weapon_name, :order => 'MaximumRequiredLevel' }
    source.query = URI.encode_www_form(parameters)

    # Create new HTTP request
    request = Net::HTTP::Get.new(source)
    request['X-Api-Key'] = Rails.configuration.destiny_api_key

    # Get response
    response = Net::HTTP.start(source.hostname, source.port, :use_ssl => source.scheme == 'https') do |http|
      http.request(request)
    end

    return JSON.parse(response.body)
  end

  def parse_weapon_stats(raw_data)
    item_hash = raw_data['Response']['data']['itemHashes'].last.to_s

    # Populate damage types (kinetic, solar, arc or void)
    raw_data['Response']['definitions']['damageTypes'].each do |damage|
      damage_enum_value = damage[1]['enumValue']
      @damage_types[damage_enum_value] = {
        :damageTypeName => damage[1]['damageTypeName'],
        :damageIconPath => damage[1]['iconPath']
      }
    end

    # Populate sources
    raw_data['Response']['definitions']['sources'].each do |source|
      source_hash = source[1]['sourceHash']
      @source_types[source_hash] = {
        :sourceName => source[1]['sourceName'],
        :sourceDesc => source[1]['description'],
        :sourceIcon => source[1]['icon']
      }
    end

    return raw_data['Response']['definitions']['items'][item_hash]
  end
end
