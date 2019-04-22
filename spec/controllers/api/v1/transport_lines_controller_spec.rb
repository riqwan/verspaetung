require 'rails_helper'

RSpec.describe Api::V1::TransportLinesController, type: :controller do
  describe "GET #show" do
    let!(:transport_line) { create(:transport_line, name: 'M4') }
    let!(:transport_delay) { create(:transport_delay, delay: 5, transport_line: transport_line) }

    context 'when transport line exists in the database' do
      let(:transport_line_id) { transport_line.id }

      it 'returns http success' do
        get :show, params: { id: transport_line_id }

        expect(response).to have_http_status(:success)
      end

      it 'JSON body response contains expected recipe attributes' do
        get :show, params: { id: transport_line_id }

        json_response = JSON.parse(response.body)
        expect(json_response.keys).to match_array(['id', 'name', 'is_delayed'])
      end

      context 'when line is delayed' do
        it 'returns true for delayed attribute' do
          get :show, params: { id: transport_line_id }

          json_response = JSON.parse(response.body)
          expect(json_response['is_delayed']).to be_truthy
        end
      end

      context 'when line is not delayed' do
        before do
          transport_delay.destroy
        end

        it 'returns false for delayed attribute' do
          get :show, params: { id: transport_line_id }

          json_response = JSON.parse(response.body)
          expect(json_response['is_delayed']).to be_falsy
        end
      end
    end

    context 'when transport line does not exist in the database' do
      let(:transport_line_id) { 99999 }

      it 'returns http 404' do
        get :show, params: { id: transport_line_id }

        expect(response).to have_http_status(404)
      end

      it 'JSON body response contains expected recipe attributes' do
        get :show, params: { id: transport_line_id }

        json_response = JSON.parse(response.body)
        expect(json_response.keys).to match_array(['error'])
      end

      it 'shows error message' do
        get :show, params: { id: transport_line_id }

        json_response = JSON.parse(response.body)
        expect(json_response['error']).to eq "Couldn't find TransportLine with 'id'=#{transport_line_id}"
      end
    end
  end
end
