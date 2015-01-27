require 'rails_helper'

RSpec.describe "Questions API" do
  describe 'GET /index'do

    context 'unauthorized' do
      it "when there is no access token returns 401 status" do
        get '/api/v1/questions', format: :json
        expect(response.status).to eq 401
      end

      it "when access token is invalid returns 401 status" do
        get '/api/v1/questions', format: :json, access_token: '123'
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token).token }
      let(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let!(:answer) { create(:answer, question: question) }
      before { get '/api/v1/questions', format: :json, access_token: access_token }

      it "returns 200 status" do
        expect(response).to be_success
      end

      it "return list of questions" do
        expect(response.body).to have_json_size(2).at_path('questions')
      end

      [:id, :title, :question, :created_at, :updated_at].each do |attr|
        it "question contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr).to_json).at_path("questions/0/#{attr}")
        end
      end

      context 'answers' do
        it "included in question object" do
          expect(response.body).to have_json_size(1).at_path("questions/0/answers")
        end

        [:id, :answer, :created_at, :updated_at].each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(answer.send(attr).to_json).at_path("questions/0/answers/0/#{attr}")
          end
        end
      end
    end
  end
end
