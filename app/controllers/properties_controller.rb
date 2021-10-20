# frozen_string_literal: true

class PropertiesController < ApplicationController
  rescue_from ActionController::BadRequest, with: :bad_request

  def index
    properties   = Property.search_within_5km(**property_params).order(distance: :asc)
    json         = { properties: properties.as_json }
    json[:error] = 'No results found.' if properties.empty?

    render json: json
  end

  private

  def bad_request
    error = 'You need to provide the parameters "lat", "lng", "property_type" and "marketing_type".'
    render status: :bad_request, json: { error: error }
  end

  def property_params
    unless params[:lat] && params[:lng] && params[:property_type] && params[:marketing_type]
      raise ActionController::BadRequest
    end

    params.permit(:lat, :lng, :property_type, :marketing_type).to_h.symbolize_keys
  end
end
