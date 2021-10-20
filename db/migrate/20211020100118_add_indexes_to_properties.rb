# frozen_string_literal: true

class AddIndexesToProperties < ActiveRecord::Migration[6.1]
  def change
    add_index :properties, :property_type
    add_index :properties, :offer_type
    add_index :properties, 'll_to_earth(lat, lng)', using: :gist
  end
end
