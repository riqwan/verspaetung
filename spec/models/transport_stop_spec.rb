require 'rails_helper'

RSpec.describe TransportStop, type: :model do
  it { should have_many(:transport_times) }
  it { should validate_presence_of(:x) }
  it { should validate_presence_of(:y) }

  describe '#next_transport_time' do
    let!(:transport_line) { create(:transport_line, name: 'M4') }
    let!(:transport_stop) { create(:transport_stop, x: x, y: y) }
    let!(:transport_time_1) { create(:transport_time, time: time_1, transport_line: transport_line, transport_stop: transport_stop) }
    let!(:transport_time_2) { create(:transport_time, time: time_2, transport_line: transport_line, transport_stop: transport_stop) }
    let(:x) { 4 }
    let(:y) { 4 }
    let(:time_1) { frozen_time - 1.day }
    let(:time_2) { frozen_time + 1.day }
    let(:frozen_time) { Time.local(2018, 10, 10, 10, 0, 0) }

    before { Timecop.freeze(frozen_time) }
    after { Timecop.return }

    context 'when transport is available' do
      it 'returns next transport object' do
        expect(transport_stop.next_transport_time.id).to eq transport_time_2.id
      end
    end

    context 'when no transport is available' do
      let(:time_2) { frozen_time - 2.days }

      it 'returns nil' do
        expect(transport_stop.next_transport_time).to be_nil
      end
    end
  end
end
