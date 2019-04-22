class TransportLine < ApplicationRecord
  # Associations
  has_many :transport_times
  has_one :transport_delay

  # Validations
  validates :name, presence: true

  def is_delayed
    return false if transport_delay.blank?

    transport_delay.delay > 0
  end
end
