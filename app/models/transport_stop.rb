class TransportStop < ApplicationRecord
  # Associations
  has_many :transport_times
  has_one :next_transport_time, class_name: 'TransportTime'

  # Validations
  validates :x, :y, presence: true

  def next_transport_time
    transport_times.where("time > ?", Time.zone.now).order('time ASC').first
  end
end
