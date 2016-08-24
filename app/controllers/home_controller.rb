class HomeController < ApplicationController

  def index
    primary_weapon = params[:primary]
    secondary_weapon = params[:secondary]

    # Get weapons data and stats
    @primary = parse_weapon_stats(get_weapon_stats(primary_weapon))
    @secondary = parse_weapon_stats(get_weapon_stats(secondary_weapon))

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
    # Define basic parameters
    source = URI('https://www.bungie.net/Platform/Destiny/Explorer/Items/')
    token = Rails.configuration.destiny_api_key
    parameters = { :definitions => true, :lc => 'pt-br', :name => weapon_name }
    source.query = URI.encode_www_form(parameters)

    # Create new HTTP request
    request = Net::HTTP::Get.new(source)
    request['X-Api-Key'] = token

    # Get response
    response = Net::HTTP.start(source.hostname, source.port, :use_ssl => source.scheme == 'https') do |http|
      http.request(request)
    end

    return JSON.parse(response.body)
  end

  def parse_weapon_stats(raw_data)
    item_hash = raw_data['Response']['data']['itemHashes'].last.to_s
    return raw_data['Response']['definitions']['items'][item_hash]
  end
end
