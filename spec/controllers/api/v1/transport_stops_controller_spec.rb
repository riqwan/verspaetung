require 'rails_helper'

RSpec.describe Api::V1::TransportStopsController, type: :controller do
  let(:frozen_time) { Time.local(2018, 10, 10, 10, 0, 0) }

  before { Timecop.freeze(frozen_time) }
  after { Timecop.return }

  describe "GET #show" do
    let!(:transport_line) { create(:transport_line, name: 'M4') }
    let!(:transport_stop) { create(:transport_stop, x: x, y: y) }
    let!(:transport_time_1) { create(:transport_time, time: time_1, transport_line: transport_line, transport_stop: transport_stop) }
    let(:x) { 4 }
    let(:y) { 4 }
    let(:time_1) { frozen_time + 1.day }

    context 'when transport line exists in the database' do
      let(:transport_stop_id) { transport_stop.id }

      it 'returns http success' do
        get :show, params: { id: transport_stop_id }

        expect(response).to have_http_status(:success)
      end

      it 'JSON body response contains expected recipe attributes' do
        get :show, params: { id: transport_stop_id }

        json_response = JSON.parse(response.body)
        expect(json_response.keys).to match_array(['id', 'x', 'y', 'next_transport_time'])
      end

      context 'when next transport time is present' do
        it 'returns transport time object for next available transport' do
          get :show, params: { id: transport_stop_id }

          json_response = JSON.parse(response.body)
          expect(json_response['next_transport_time']['time'].to_datetime).to eq transport_time_1.time
        end
      end

      context 'when next transport time is not available' do
        let(:time_1) { frozen_time - 2.days }

        it 'returns transport time object for next available transport' do
          get :show, params: { id: transport_stop_id }

          json_response = JSON.parse(response.body)
          expect(json_response['next_transport_time']).to be_nil
        end
      end
    end

    context 'when transport line does not exist in the database' do
      let(:transport_stop_id) { 99999 }

      it 'returns http 404' do
        get :show, params: { id: transport_stop_id }

        expect(response).to have_http_status(404)
      end

      it 'JSON body response contains expected recipe attributes' do
        get :show, params: { id: transport_stop_id }

        json_response = JSON.parse(response.body)
        expect(json_response.keys).to match_array(['error'])
      end

      it 'shows error message' do
        get :show, params: { id: transport_stop_id }

        json_response = JSON.parse(response.body)
        expect(json_response['error']).to eq "Couldn't find TransportStop with 'id'=#{transport_stop_id}"
      end
    end
  end
end
