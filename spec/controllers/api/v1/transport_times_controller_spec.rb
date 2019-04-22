require 'rails_helper'

RSpec.describe Api::V1::TransportTimesController, type: :controller do
  let(:frozen_time) { Time.local(2018, 10, 10, 10, 0, 0) }

  before { Timecop.freeze(frozen_time) }
  after { Timecop.return }

  describe "GET #show" do
    let!(:transport_line) { create(:transport_line, name: 'M4') }
    let!(:transport_stop) { create(:transport_stop, x: x, y: y) }
    let!(:transport_time_1) { create(:transport_time, time: time_1, transport_line: transport_line, transport_stop: transport_stop) }
    let!(:transport_time_2) { create(:transport_time, time: time_2, transport_line: transport_line, transport_stop: transport_stop) }
    let(:x) { 4 }
    let(:y) { 4 }
    let(:time_1) { frozen_time + 1.day }
    let(:time_2) { frozen_time - 1.day }
    let(:time_3) { frozen_time + 60.days }

    context 'when transport stop exists in the database' do
      let(:transport_stop_id) { transport_stop.id }

      it 'returns http success' do
        get :show, params: { x: x, y: y, time: time_1.to_s }

        expect(response).to have_http_status(:success)
      end

      it 'JSON body response contains expected recipe attributes' do
        get :show, params: { x: x, y: y, time: time_1.to_s }

        json_response = JSON.parse(response.body)
        expect(json_response.keys).to match_array(['id', 'time'])
      end

      context 'when next transport time is present' do
        it 'returns transport time object for next available transport' do
          get :show, params: { x: x, y: y, time: time_1.to_s }

          json_response = JSON.parse(response.body)
          expect(json_response['time'].to_datetime).to eq transport_time_1.time
        end
      end

      context 'when next transport time is not available' do
        let(:time_1) { frozen_time - 2.days }

        it 'returns transport time object for next available transport' do
          get :show, params: { x: x, y: y, time: 90.days.ago }

          json_response = JSON.parse(response.body)
          expect(json_response).to eq({})
        end
      end
    end

    context 'when transport stop does not exist in the database' do
      let(:x_mock) { 0 }
      let(:y_mock) { 0 }

      it 'returns http 400' do
        get :show, params: { x: x_mock, y: y_mock, time: time_3.to_s }

        expect(response).to have_http_status(400)
      end

      it 'JSON body response contains expected recipe attributes' do
        get :show, params: { x: x_mock, y: y_mock, time: time_3.to_s }

        json_response = JSON.parse(response.body)
        expect(json_response.keys).to match_array(['error'])
      end

      it 'shows error message' do
        get :show, params: { x: x_mock, y: y_mock, time: time_3.to_s }

        json_response = JSON.parse(response.body)
        expect(json_response['error']['x'].first).to eq "transport stop with (x/y) value must exist"
        expect(json_response['error']['y'].first).to eq "transport stop with (x/y) value must exist"
      end
    end

    context 'when transport time does not exist in the database' do
      it 'returns http 200' do
        get :show, params: { x: x, y: y, time: time_3.to_s }

        expect(response).to have_http_status(200)
      end

      it 'returns an empty json response' do
        get :show, params: { x: x, y: y, time: time_3.to_s }

        json_response = JSON.parse(response.body)
        expect(json_response).to eq({})
      end

      context 'when datetime format is invalid' do
        it 'shows error message' do
          get :show, params: { x: x, y: y, time: 'invalid string' }

          json_response = JSON.parse(response.body)
          expect(json_response['error']['time'].first).to eq "must be of valid datetime format"
        end
      end
    end
  end
end
