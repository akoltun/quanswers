require 'rails_helper'

RSpec.describe AnswersController, :type => :controller do

  describe "POST #create" do
    let(:post_request) { post :create, question_id: answer_hash[:question_id], answer: answer_hash }

    context "with valid attributes" do
      let(:answer_hash) { build(:answer).attributes.symbolize_keys }

      it "redirects to show view" do
        post_request
        expect(response).to redirect_to question_path(answer_hash[:question_id])
      end

      it "creates new answer in db" do
        expect { post_request }.to change(Answer, :count).by(1)
      end

      it "assigns a success message to flash[:notice]" do
        post_request
        expect(flash[:notice]).to eql "You have created a new answer"
      end
    end

    context "with invalid attributes" do
      let(:answer_hash) { build(:invalid_answer).attributes.symbolize_keys }

      it "re-renders question show view" do
        post_request
        expect(response).to render_template "questions/show"
      end

      it "does not create new answer in db" do
        expect { post_request }.not_to change(Answer, :count)
      end

      it "assigns an error message to flash[:alert]" do
        post_request
        expect(flash[:alert]).to eql ["Answer can't be blank"]
      end
    end
  end

end
