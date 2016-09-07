class PilotsController < ApplicationController
  def index
    @pilots = Pilot.order("name ASC")
  end

  def laps
    @pilot = Pilot.find(params[:id])
  end
end
