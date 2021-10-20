# frozen_string_literal: true

class Property < ApplicationRecord
  JSON_ATTRIBUTES = %i[
    house_number
    street
    city
    zip_code
    lat
    lng
    price
  ].freeze

  FIVE_KM_IN_METERS = 5000

  # the gist index on ll_to_earth(lat, lng) can only be used by the cube @> operator but
  # some points in the earth box are further than the specified great circle distance from the location
  # so we need a second check using earth_distance to really get the 5km radius
  scope :search_within_5km, ->(lat:, lng:, property_type:, marketing_type:) {
    distance = "earth_distance(ll_to_earth(#{lat}, #{lng}), ll_to_earth(lat, lng))"

    where(offer_type: marketing_type, property_type: property_type)
      .where(
        <<~SQL
          earth_box(ll_to_earth(#{lat}, #{lng}), #{FIVE_KM_IN_METERS}) @> ll_to_earth(lat, lng)
          AND
          #{distance} <= #{FIVE_KM_IN_METERS}
        SQL
      ).select("properties.*, #{distance} as distance")
  }

  def as_json(options = { only: JSON_ATTRIBUTES, methods: [:distance] })
    super
  end
end
