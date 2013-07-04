class ParkingsController < ApplicationController
  before_filter :load_data

  def index
    respond_to do |format|
      format.html
      format.json do
        render json: @parkings
      end
    end
  end

  def embed
    render :action => "index"
  end

  private

  def load_data
    @parkings = Parking.all
  end
end
