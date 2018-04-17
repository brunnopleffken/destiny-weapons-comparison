class D2::SearchController < ApplicationController
  def index
    #
  end

  def autocomplete
    # Check if API key is defined in config/initializers
    raise "The Bungie API key is not defined." if Rails.configuration.destiny_api_key.blank?

    results = []

    query = ActiveRecord::Base.connection.exec_query("SELECT json FROM DestinyInventoryItemDefinition
      WHERE json LIKE '%\"name\":\"%#{params[:term]}%\"%'
      AND json LIKE '%\"itemType\":3%';")

    query.rows.each do |r|
      results << JSON.parse(r[0])
    end

    render json: results and return
    # render json: JSON.parse(results[0][0]) and return
  end
end
