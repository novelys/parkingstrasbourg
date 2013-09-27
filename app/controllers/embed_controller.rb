class EmbedController < ApplicationController
  before_filter :load_parkings
  respond_to :html

  def index
    respond_with @parkings
  end
end
