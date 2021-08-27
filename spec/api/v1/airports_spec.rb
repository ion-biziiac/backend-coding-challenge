require 'rails_helper'

RSpec.describe 'API::V1::AirportsController', type: :request do
  describe 'show' do
    def airports_request(params = {})
      json_get api_v1_airports_url, params: params
    end

    before do
      %i[fra muc zrh vie inn grz].each { |iata| create(:airport, iata) }
    end

    it 'returns airports', :aggregate_failures do
      airports_request

      expect(response.status).to eq(200)
      expect(json.size).to eq(6)
    end

    it 'returns airports filtered by countries', :aggregate_failures do
      airports_request(countries: %w[DE CH])

      expect(response.status).to eq(200)
      expect(json.size).to eq(3)
      expect(json.map { |ap| ap[:iata] }).to eq(%w[FRA MUC ZRH])
    end

    it 'returns airports ordered by capacity descending', :aggregate_failures do
      Airport.find_by(iata: 'ZRH').update(passenger_volume: 987234)
      Airport.find_by(iata: 'VIE').update(passenger_volume: 456832)

      airports_request

      expect(response.status).to eq(200)
      expect(json.size).to eq(6)
      expect(json.map { |ap| ap[:iata] }).to eq(%w[ZRH VIE FRA MUC INN GRZ])
    end

    it 'paginates the records', :aggregate_failures do
      airports_request(page: 2, per_page: 3)

      expect(response.status).to eq(200)
      expect(json.size).to eq(3)
      expect(json.map { |ap| ap[:iata] }).to eq(%w[VIE INN GRZ])
    end
  end
end
