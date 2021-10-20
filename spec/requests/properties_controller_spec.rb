# frozen_string_literal: true

require 'rails_helper'

describe 'PropertiesController' do
  context 'missing parameters' do
    it 'responds with bad request' do
      get properties_path(lng: 123, marketing_type: 'sell', property_type: 'apartment')
      expect(response.status).to eq 400

      error = 'You need to provide the parameters "lat", "lng", "property_type" and "marketing_type".'
      expect(response.body).to eq({ error: error }.to_json)

      get properties_path(lat: 123, marketing_type: 'sell', property_type: 'apartment')
      expect(response.status).to eq 400

      get properties_path(lat: 123, lng: 123, property_type: 'apartment')
      expect(response.status).to eq 400

      get properties_path(lat: 123, lng: 123, marketing_type: 'sell')
      expect(response.status).to eq 400
    end
  end

  it 'returns error message if nothing could be found' do
    get properties_path(lat: 123, lng: 123, marketing_type: 'sell', property_type: 'apartment')
    expect(response.status).to eq 200
    expect(response.body).to eq({ properties: [], error: 'No results found.' }.to_json)
  end

  context 'with existing properties' do
    let!(:sell_apartment_too_far_away) do
      Property.create!(
        house_number:  '52',
        street:        'Berliner Str.',
        city:          'Berlin',
        zip_code:      '13127',
        lat:           '52.5970126',
        lng:           '13.4313026',
        price:         '350000',
        offer_type:    'sell',
        property_type: 'apartment'
      )
    end
    let!(:sell_apartment_further_away) do
      Property.create!(
        house_number:  '44',
        street:        'Damerowstraße',
        city:          'Berlin',
        zip_code:      '13187',
        lat:           '52.5746549',
        lng:           '13.4223677',
        price:         '350000',
        offer_type:    'sell',
        property_type: 'apartment'
      )
    end
    let!(:sell_apartment) do
      Property.create!(
        house_number:  '31',
        street:        'Marienburger Straße sell apartment',
        city:          'Berlin',
        zip_code:      '10405',
        lat:           '52.534993',
        lng:           '13.4211476',
        price:         '350000',
        offer_type:    'sell',
        property_type: 'apartment'
      )
    end
    let!(:rent_apartment) do
      Property.create!(
        house_number:  '31',
        street:        'Marienburger Straße rent apartment',
        city:          'Berlin',
        zip_code:      '10405',
        lat:           '52.534993',
        lng:           '13.4211476',
        price:         '350000',
        offer_type:    'rent',
        property_type: 'apartment'
      )
    end
    let!(:sell_house) do
      Property.create!(
        house_number:  '31',
        street:        'Marienburger Straße sell house',
        city:          'Berlin',
        zip_code:      '10405',
        lat:           '52.534993',
        lng:           '13.4211476',
        price:         '350000',
        offer_type:    'sell',
        property_type: 'single_family_house'
      )
    end
    let!(:rent_house) do
      Property.create!(
        house_number:  '31',
        street:        'Marienburger Straße rent house',
        city:          'Berlin',
        zip_code:      '10405',
        lat:           '52.534993',
        lng:           '13.4211476',
        price:         '350000',
        offer_type:    'rent',
        property_type: 'single_family_house'
      )
    end

    it 'renders list of properties within 5km of the coordinates filtered by marketing and property type' do
      get properties_path(lat: '52.536136', lng: '13.433012', marketing_type: 'sell', property_type: 'apartment')
      expect(response.status).to eq 200
      expect(JSON.parse(response.body)).to eq(
        {
          properties: [
            {
              street:       'Marienburger Straße sell apartment',
              house_number: '31',
              zip_code:     '10405',
              city:         'Berlin',
              distance:     813.3820298896117,
              lat:          '52.534993',
              lng:          '13.4211476',
              price:        '350000.0'
            },
            {
              street:       'Damerowstraße',
              house_number: '44',
              zip_code:     '13187',
              city:         'Berlin',
              distance:     4348.024471396312,
              lat:          '52.5746549',
              lng:          '13.4223677',
              price:        '350000.0'
            }
          ]
        }.deep_stringify_keys
      )
    end
  end
end
