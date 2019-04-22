require 'rails_helper'

RSpec.describe TransportLine, type: :model do
  it { should have_many(:transport_times) }
  it { should have_one(:transport_delay) }
  it { should validate_presence_of(:name) }

  describe '#is_delayed' do
    let!(:transport_line) { described_class.new(name: 'M4') }

    context 'when transportation delay record doesnt exist' do
      it 'returns false' do
        expect(transport_line.is_delayed).to be_falsy
      end
    end

    context 'when transport delay record exists' do
      let!(:transport_delay) { create(:transport_delay, delay: delay, transport_line: transport_line) }

      context 'when delay value is 0' do
        let(:delay) { 0 }

        it 'returns false' do
          expect(transport_line.is_delayed).to be_falsy
        end
      end

      context 'when delay value is not 0' do
        let(:delay) { 5 }

        it 'returns true' do
          expect(transport_line.is_delayed).to be_truthy
        end
      end
    end
  end
end
