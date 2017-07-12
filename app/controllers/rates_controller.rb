class RatesController < ApplicationController
  def show
    @indicators = Indicator.all.map { |indicator| indicator.broadcast_attributes }
  end
end
