class Api::V1::TransportLinesController < ApplicationController
  def show
    transport_line = TransportLine.find(params[:id])

    render json: transport_line, serializer: Api::V1::TransportLineSerializer
  end
end
