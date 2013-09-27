class ParkingsController < ApplicationController
  before_filter :load_parkings
  respond_to :html, :json

  def index
    respond_with @parkings
  end

  def map
    @json = @parkings.map { |o| ParkingSerializer.new(o) }.to_json.html_safe
  end
end
