require 'rails_helper'

RSpec.describe TransportTime, type: :model do
  it { should belong_to(:transport_stop) }
  it { should belong_to(:transport_line) }

  it { should validate_presence_of(:time) }
end
