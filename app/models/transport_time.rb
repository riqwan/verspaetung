class TransportTime < ApplicationRecord
  # Associations
  belongs_to :transport_stop
  belongs_to :transport_line

  # Validations
  validates :time, presence: true
end
