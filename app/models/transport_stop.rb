class TransportStop < ApplicationRecord
  validates :x, :y, presence: true
end
