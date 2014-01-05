class ParamsController < ApplicationController

  def provinces

    provinces = []

    begin
      country = Country.find params[:country_id]
      provinces = Province.where :country => country
    rescue
    end

    respond_to do |format|
      format.json {render :json => provinces}
    end

  end

  def cities

    provinces = []

    begin
      country = Country.find params[:country_id]
      provinces = Province.where :country => country
    rescue
    end

    respond_to do |format|
      format.json {render :json => provinces}
    end

  end

end