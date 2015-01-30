require 'rails_helper'

RSpec.describe "Answers API" do
  describe 'GET /index'do
    let!(:question) { create(:question) }

    it_behaves_like "api authorizable"
    def do_request(options = {})
      get "/api/v1/questions/#{question.id}/answers", { format: :json }.merge(options)
    end

    context 'authorized' do
      let(:access_token) { create(:access_token).token }
      let!(:answers) { create_list(:answer, 2, question: question) }
      let!(:answer) { answers.first }
      before { get "/api/v1/questions/#{question.id}/answers", format: :json, access_token: access_token }

      it_behaves_like "a success request"
      it_behaves_like "a list of", 2, "answers", [:answer]
    end
  end

  describe 'GET /show' do
    let(:answer) { create(:answer) }

    it_behaves_like "api authorizable"
    def do_request(options = {})
      get "/api/v1/answers/#{answer.id}", { format: :json }.merge(options)
    end

    context 'authorized' do
      let(:access_token) { create(:access_token).token }
      let!(:remark) { create(:remark, remarkable: answer) }
      let!(:attachment) { create(:attachment, attachmentable: answer) }
      before { get "/api/v1/answers/#{answer.id}", format: :json, access_token: access_token }

      it_behaves_like "a success request"

      [:id, :answer, :created_at, :updated_at].each do |attr|
        it "answer contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr).to_json).at_path("answer/#{attr}")
        end
      end

      it_behaves_like "a remarkable", "answer"
      it_behaves_like "an attachmentable", "answer"
    end
  end

  describe 'POST /create' do
    let!(:question) { create(:question) }
    let(:answer) { { answer: 'My answer' } }

    it_behaves_like "api authorizable"
    def do_request(options = {})
      post "/api/v1/questions/#{question.id}/answers", { question_id: question, answer: answer, format: :json }.merge(options)
    end

    context 'authorized' do
      let(:access_token) { create(:access_token).token }
      let(:post_request) { post "/api/v1/questions/#{question.id}/answers", question_id: question, answer: answer, format: :json, access_token: access_token }

      context "with valid attributes" do
        it "returns 201 status" do
          post_request
          expect(response).to have_http_status(201)
        end

        it "creates answer in database" do
          expect { post_request }.to change(question.answers, :count).by(1)
        end

        it "creates answer with correct data" do
          post_request
          expect(question.answers.first.answer).to eq answer[:answer]
        end
      end

      context "with invalid attributes" do
        let(:answer) { { answer: nil } }

        it "returns 422 status" do
          post_request
          expect(response).to have_http_status(422)
        end

        it "does not create new answer in database" do
          expect { post_request }.not_to change(Answer, :count)
        end

        it "returns list of errors" do
          post_request
          expect(response.body).to have_json_size(1).at_path('errors/answer')
        end

        it "returns error message" do
          post_request
          expect(response.body).to be_json_eql("can't be blank".to_json).at_path('errors/answer/0')
        end
      end
    end
  end
end
