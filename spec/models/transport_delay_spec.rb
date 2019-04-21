require 'rails_helper'

RSpec.describe TransportDelay, type: :model do
  it { should belong_to(:transport_line) }

  it { should validate_presence_of(:delay) }
end
