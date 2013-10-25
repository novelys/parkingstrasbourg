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

  def embed
    render action: :index
  end

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
