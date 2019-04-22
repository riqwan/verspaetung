class Api::V1::TransportLineSerializer < ActiveModel::Serializer
  attributes :id, :name, :is_delayed
end
