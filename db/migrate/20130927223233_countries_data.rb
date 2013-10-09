class CountriesData < ActiveRecord::Migration
  def change

    Country.create :name => 'Argentina'

  end
end
