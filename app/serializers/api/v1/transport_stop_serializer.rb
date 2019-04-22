class Api::V1::TransportStopSerializer < ActiveModel::Serializer
  attributes :id, :x, :y

  has_one :next_transport_time, serializer: Api::V1::TransportTimeSerializer
end
