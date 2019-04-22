require 'rails_helper'

describe TransportTimes::VehicleFinder, type: :model do
  let(:frozen_time) { Time.local(2018, 10, 10, 10, 0, 0) }

  before { Timecop.freeze(frozen_time) }

  after { Timecop.return }

  it { should validate_presence_of(:x) }
  it { should validate_presence_of(:y) }
  it { should validate_presence_of(:time) }
  it { should validate_numericality_of(:x) }
  it { should validate_numericality_of(:y) }

  describe '#find' do
    let!(:transport_line) { create(:transport_line, name: 'M4') }
    let!(:transport_stop) { create(:transport_stop, x: x, y: y) }
    let!(:transport_time_1) { create(:transport_time, time: time_1, transport_line: transport_line, transport_stop: transport_stop) }
    let(:x) { 4 }
    let(:y) { 4 }
    let(:time_1) { frozen_time + 1.day }
    let(:time_2) { frozen_time - 1.day }

    context 'when transport time for a particular (x/y) at a specific time exists' do
      it 'returns a json with attributes from transport time model' do
        klass = described_class.new({ x: x, y: y, time: time_1 })

        expect(klass.valid?).to be_truthy
        expect(klass.find.id).to eq transport_time_1.id
      end
    end

    context 'when transport time for a particular (x/y) at a specific time does not exists' do
      it 'returns a json with attributes from transport time model' do
        klass = described_class.new({ x: x, y: y, time: time_2 })

        expect(klass.valid?).to be_truthy
        expect(klass.find).to be_nil
      end
    end
  end

  describe '#invalid?' do
    let(:x) { 4 }
    let(:y) { 6 }

    context 'when invalid time param is passed into the service' do
      let!(:transport_stop) { create(:transport_stop, x: x, y: y) }
      let!(:transport_line) { create(:transport_line, name: 'M4') }

      it 'returns invalid true with errors' do
        klass = described_class.new({ x: x, y: y, time: 'invalid format' })

        expect(klass.invalid?).to be_truthy
        expect(klass.errors.messages).to eq ({
          time: ["must be of valid datetime format"]
        })
      end
    end

    context 'when transport stop isnt available' do
      let!(:transport_stop) { create(:transport_stop, x: x, y: y) }
      let!(:transport_line) { create(:transport_line, name: 'M4') }

      it 'returns invalid true with errors' do
        klass = described_class.new({ x: 55, y: 55, time: Time.zone.now })

        expect(klass.invalid?).to be_truthy
        expect(klass.errors.messages).to eq ({
          x: ['transport stop with (x/y) value must exist'],
          y: ['transport stop with (x/y) value must exist'],
        })
      end
    end
  end
end
