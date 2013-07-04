class ParkingsController < ApplicationController
  before_filter :load_data

  def index
  end

  def embed
    render :action => "index"
  end

  private

  def load_data
    @parkings = Parking.all
  end
end
