class MapController < ApplicationController
  def index
    @line = Line.new
  end
end