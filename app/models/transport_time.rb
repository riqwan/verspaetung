class TransportTime < ApplicationRecord
  belongs_to :transport_stop
  belongs_to :transport_line
end
