class ParkingsController < ApplicationController
  before_filter :load_data
  respond_to :html, :json

  def index
    respond_with @parkings
  end

  def embed
    render action: :index
  end

  private

  def load_data
    @parkings = Parking.all
  end
end
