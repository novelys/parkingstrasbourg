class ParkingsController < ApplicationController
  before_filter :load_data
  respond_to :html, :json

  def index
    respond_with @parkings
  end

  def embed
    render action: :index
  end

  def map
    @json = @parkings.map { |o| ParkingSerializer.new(o) }.to_json.html_safe
  end

  private

  def load_data
    @parkings = Parking.all
  end
end
