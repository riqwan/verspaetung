class Api::V1::TransportStopsController < ApplicationController
  def show
    transport_stop = TransportStop.find(params[:id])

    render json: transport_stop, serializer: Api::V1::TransportStopSerializer
  end
end
