class Api::V1::TransportTimeSerializer < ActiveModel::Serializer
  attributes :id, :time

  belongs_to :transport_stop
  belongs_to :transport_line
end
