require 'rails_helper'

RSpec.describe "Questions API" do
  describe 'GET /index'do

    it_behaves_like "api authorizable"
    def do_request(options = {})
      get '/api/v1/questions', { format: :json }.merge(options)
    end

    context 'authorized' do
      let(:access_token) { create(:access_token).token }
      let(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let!(:answer) { create(:answer, question: question) }
      before { get '/api/v1/questions', format: :json, access_token: access_token }

      it_behaves_like "a success request"
      it_behaves_like "a list of", 2, "questions", [:title, :question]

      context 'answers included in question object' do
        it_behaves_like "a list of", 1, "answer", [:answer], "questions/0/"
      end
    end
  end

  describe 'GET /show' do
    let(:question) { create(:question) }

    it_behaves_like "api authorizable"
    def do_request(options = {})
      get "/api/v1/questions/#{question.id}", { format: :json }.merge(options)
    end

    context 'authorized' do
      let(:access_token) { create(:access_token).token }
      let!(:remark) { create(:remark, remarkable: question) }
      let!(:attachment) { create(:attachment, attachmentable: question) }
      before { get "/api/v1/questions/#{question.id}", format: :json, access_token: access_token }

      it_behaves_like "a success request"

      [:id, :title, :question, :created_at, :updated_at].each do |attr|
        it "question contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr).to_json).at_path("question/#{attr}")
        end
      end

      it_behaves_like "a remarkable", "question"
      it_behaves_like "an attachmentable", "question"
    end
  end

  describe 'POST /create' do
    let(:question) { { title: 'My title', question: 'My question' } }

    it_behaves_like "api authorizable"
    def do_request(options = {})
      post "/api/v1/questions/", { question: question, format: :json }.merge(options)
    end

    context 'authorized' do
      let(:access_token) { create(:access_token).token }
      let(:post_request) { post "/api/v1/questions/", question: question, format: :json, access_token: access_token }

      context "with valid attributes" do
        it "returns 201 status" do
          post_request
          expect(response).to have_http_status(201)
        end

        it "creates question in database" do
          expect { post_request }.to change(Question, :count).by(1)
        end

        it "creates question with correct data" do
          post_request
          new_question = Question.first
          expect(new_question.title).to eq question[:title]
          expect(new_question.question).to eq question[:question]
        end
      end

      context "with invalid attributes" do
        let(:question) { { question: 'My question' } }

        it "returns 422 status" do
          post_request
          expect(response).to have_http_status(422)
        end

        it "does not create new question in database" do
          expect { post_request }.not_to change(Question, :count)
        end

        it "returns list of errors" do
          post_request
          expect(response.body).to have_json_size(1).at_path('errors/title')
        end

        it "returns error message" do
          post_request
          expect(response.body).to be_json_eql("can't be blank".to_json).at_path('errors/title/0')
        end
      end
    end
  end
end
