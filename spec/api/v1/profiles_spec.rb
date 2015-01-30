require 'rails_helper'

RSpec.describe "Profile API" do
  describe 'GET /me'do
    it_behaves_like "api authorizable"
    def do_request(options = {})
      get '/api/v1/profiles/me', { format: :json }.merge(options)
    end

    context 'authorized' do
      let(:user) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: user.id).token }
      before { get '/api/v1/profiles/me', format: :json, access_token: access_token }

      it_behaves_like "a success request"

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
    it_behaves_like "api authorizable"
    def do_request(options = {})
      get '/api/v1/profiles', { format: :json }.merge(options)
    end

    context 'authorized' do
      let(:users) { create_list(:user, 3) }
      let(:user) { users.first }
      let(:access_token) { create(:access_token, resource_owner_id: users.last.id).token }
      before { get '/api/v1/profiles', format: :json, access_token: access_token }

      it_behaves_like "a success request"

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
