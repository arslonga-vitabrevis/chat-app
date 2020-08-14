class RoomsController < ApplicationController
  def create
    @room=Room.new
  end
end
