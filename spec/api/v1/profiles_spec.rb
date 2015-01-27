require 'rails_helper'

RSpec.describe "Profile API" do
  describe 'GET /me'do
    context 'unauthorized' do
      it "when there is no access token returns 401 status" do
        get '/api/v1/profiles/me', format: :json
        expect(response.status).to eq 401
      end

      it "when access token is invalid returns 401 status" do
        get '/api/v1/profiles/me', format: :json, access_token: '123'
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:user) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: user.id).token }
      before { get '/api/v1/profiles/me', format: :json, access_token: access_token }

      it "returns 200 status" do
        expect(response).to be_success
      end

      [:id, :email, :username, :created_at, :updated_at].each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(user.send(attr).to_json).at_path("user/#{attr}")
        end
      end

      [:password, :encrypted_password].each do |attr|
        it "does not contain #{attr}" do
          expect(response.body).not_to have_json_path("user/#{attr}")
        end
      end
    end
  end

  describe 'GET /index'do
    context 'unauthorized' do
      it "when there is no access token returns 401 status" do
        get '/api/v1/profiles', format: :json
        expect(response.status).to eq 401
      end

      it "when access token is invalid returns 401 status" do
        get '/api/v1/profiles', format: :json, access_token: '123'
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:users) { create_list(:user, 3) }
      let(:user) { users.first }
      let(:access_token) { create(:access_token, resource_owner_id: users.last.id).token }
      before { get '/api/v1/profiles', format: :json, access_token: access_token }

      it "returns 200 status" do
        expect(response).to be_success
      end

      it "return list of users without current" do
        expect(response.body).to have_json_size(2).at_path('profiles')
      end

      [:id, :email, :username, :created_at, :updated_at].each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(user.send(attr).to_json).at_path("profiles/0/#{attr}")
        end
      end

      [:password, :encrypted_password].each do |attr|
        it "does not contain #{attr}" do
          expect(response.body).not_to have_json_path("profiles/0/#{attr}")
        end
      end
    end
  end
end
