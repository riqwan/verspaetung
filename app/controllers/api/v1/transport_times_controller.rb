class Api::V1::TransportTimesController < ApplicationController
  before_action :validate_params

  def show
    transport_time = TransportTimes::VehicleFinder.new(params).find

    if transport_time.present?
      render json: transport_time, serializer: Api::V1::TransportTimeSerializer
    else
      render json: {}
    end
  end

  private

  def validate_params
    vehicle_finder = TransportTimes::VehicleFinder.new(params)

    if vehicle_finder.invalid?
      render json: { error: vehicle_finder.errors }, status: :bad_request and return
    end
  end
end
