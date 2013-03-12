class ParkingsController < ApplicationController
  
  def index
  end

  def embed
    render :action => "index"
  end
end
