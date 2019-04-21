class TransportDelay < ApplicationRecord
  # Associations
  belongs_to :transport_line

  # Validations
  validates :delay, presence: true
end
