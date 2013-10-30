class ParkingsController < ApplicationController
  before_filter :load_resource, only: :show
  before_filter :load_resources

  respond_to :html, :json

  def index
    respond_with @parkings
  end

  def show
    render :index
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

  def info; end

  private

  def load_resource
    @parking = Parking.find params[:id]
  end

  def load_resources
    @parkings = Parking.all.sort_by &:sort_criteria
    @parkings.delete(@parking) if @parking
    @parkings
  end
end
