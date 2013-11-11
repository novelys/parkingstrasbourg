class ParkingsController < ApplicationController
  before_filter :load_resource, only: :show
  before_filter :load_resources, only: [:index, :embed]

  respond_to :html, :json

  def index
    respond_with @parkings
  end

  def show
  end

  def ideal
    # Sort by distance
    if params[:lat] && params[:lng]
      @parkings.sort_by! { |p| p.distance_from params.values_at(:lat, :lng)}

      method = 'fullish'
      method += "_#{params[:delay].to_i.to_s}" if params[:delay]
      method += '?'

      @parking = @parkings.reject { |parking| parking.send(method) }.first
      @parkings.delete @parking
    end

    show
  end

  def embed
    render action: :index
  end

  def faq; end

  private

  def load_resource
    @parking = Parking.find params[:id]
  end

  def load_resources
    @parkings = Parking.all
  end
end
