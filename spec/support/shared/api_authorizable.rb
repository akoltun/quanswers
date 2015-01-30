RSpec.shared_examples "api authorizable" do
  context 'unauthorized' do
    it "when there is no access token returns 401 status" do
      do_request
      expect(response.status).to eq 401
    end

    it "when access token is invalid returns 401 status" do
      do_request(access_token: '123')
      expect(response.status).to eq 401
    end
  end
end