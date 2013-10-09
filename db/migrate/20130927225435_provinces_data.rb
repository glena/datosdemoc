class ProvincesData < ActiveRecord::Migration
  def change

    country = Country.where(:name => "Argentina").first!

    Province.create :country=> country, :name=> "Ciudad Autonoma de Buenos Aires"
    Province.create :country=> country, :name=> "Buenos Aires"
    Province.create :country=> country, :name=> "Catamarca"
    Province.create :country=> country, :name=> "Chaco"
    Province.create :country=> country, :name=> "Chubut"
    Province.create :country=> country, :name=> "Cordoba"
    Province.create :country=> country, :name=> "Corrientes"
    Province.create :country=> country, :name=> "Entre Rios"
    Province.create :country=> country, :name=> "Formosa"
    Province.create :country=> country, :name=> "Jujuy"
    Province.create :country=> country, :name=> "La Pampa"
    Province.create :country=> country, :name=> "La Rioja"
    Province.create :country=> country, :name=> "Mendoza"
    Province.create :country=> country, :name=> "Misiones"
    Province.create :country=> country, :name=> "Neuquen"
    Province.create :country=> country, :name=> "Rio Negro"
    Province.create :country=> country, :name=> "Salta"
    Province.create :country=> country, :name=> "San Juan"
    Province.create :country=> country, :name=> "San Luis"
    Province.create :country=> country, :name=> "Santa Cruz"
    Province.create :country=> country, :name=> "Santa Fe"
    Province.create :country=> country, :name=> "Santiago del Estero"
    Province.create :country=> country, :name=> "Tierra del Fuego"
    Province.create :country=> country, :name=> "Tucuman"

  end
end
