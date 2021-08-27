# == Schema Information
#
# Table name: airports
#
#  id               :uuid             not null, primary key
#  altitude         :integer
#  city             :string
#  country          :string
#  country_alpha2   :string
#  dst              :string
#  iata             :string
#  icao             :string
#  kind             :string
#  latitude         :decimal(10, 6)
#  longitude        :decimal(10, 6)
#  name             :string
#  passenger_volume :integer
#  source           :string
#  timezone         :string
#  timezone_olson   :string
#  uid              :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_airports_on_iata                    (iata) UNIQUE
#  index_airports_on_iata_and_icao_and_name  (iata,icao,name)
#  index_airports_on_icao                    (icao)
#  index_airports_on_name                    (name)
#
require 'rails_helper'

RSpec.describe Airport, type: :model do
  describe '.by_capacity_descending' do
    it 'orders records by passenger_volume descending' do
      ap1 = create(:airport, :fra, passenger_volume: 123456)
      ap2 = create(:airport, :muc, passenger_volume: 543982)
      ap3 = create(:airport, :zrh)

      expect(Airport.by_capacity_descending).to eq([ap2, ap1, ap3])
    end
  end

  describe '.by_countries' do
    before do
      %i[fra muc zrh vie inn grz].each { |iata| create(:airport, iata) }
    end

    it 'filters records by country_alpha2' do
      expect(Airport.by_countries(%w[DE AT]).pluck(:iata)).to eq(%w[FRA MUC VIE INN GRZ])
    end
  end
end
