require 'rails_helper'

RSpec.describe AnswersController, :type => :controller do
  let(:question) { create(:question_with_answers) }
  let(:answer)   { question.answers[0] }

  describe "GET #edit" do
    before { get :edit, question_id: question.id, id: answer.id}

    it "renders show view" do
      expect(response).to render_template :show
    end

    it "populates requested question" do
      expect(assigns(:question)).to eq question
    end

    it "populates all answers for this question" do
      expect(assigns(:answers)).to match_array(question.answers)
    end

    it "populates requested answer" do
      expect(assigns(:answer)).to eql answer
    end
  end

  describe "POST #create" do
    let(:post_request) { post :create, question_id: answer_hash[:question_id], answer: answer_hash }
    let(:question) { Question.find(answer_hash[:question_id]) }

    context "with valid attributes" do
      let(:answer_hash) { build(:answer).attributes.symbolize_keys }

      it "redirects to show view" do
        post_request
        expect(response).to redirect_to question_path(answer_hash[:question_id])
      end

      it "creates new answer in db" do
        expect { post_request }.to change(question.answers, :count).by(1)
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

      it "populates the question to @question" do
        post_request
        expect(assigns(:question)).to eq question
      end

      it "populates all answers for this question to @answers" do
        post_request
        expect(assigns(:answers)).to match_array(question.answers)
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

  describe "PATCH #update" do
    # let(:patch_request) { patch :update, question_id: question.id, answer: answer_hash }
    before { patch :update, question_id: question, id: answer, answer: update_hash }

    context "with valid attributes" do
      let(:update_hash) { attributes_for(:another_answer) }

      it "redirects to show view" do
        expect(response).to redirect_to question
      end

      it "updates answer in db" do
        answer.reload
        expect(answer.answer).to eq update_hash[:answer]
      end

      it "assigns the question to @question" do
        expect(assigns(:question)).to eq question
      end

      it "assigns requested answer to @answer" do
        expect(assigns(:answer)).to eq answer
      end

      it "assigns a success message to flash[:notice]" do
        expect(flash[:notice]).to eql "You have updated the answer"
      end
    end

    context "with invalid attributes" do
      let(:update_hash) { attributes_for(:invalid_answer) }
      let(:answer_hash) { attributes_for(:answer) }

      it 're-renders show view' do
        expect(response).to render_template 'questions/show'
      end

      it "does not change answer in db" do
        answer.reload
        expect(answer.answer).to eq answer_hash[:answer]
      end

      it "populates the question to @question" do
        expect(assigns(:question)).to eq question
      end

      it "populates all answers for this question to @answers" do
        expect(assigns(:answers)).to match_array(question.answers)
      end

      it "assigns an error message to flash[:alert]" do
        expect(flash[:alert]).to eql ["Answer can't be blank"]
      end
    end
  end

  describe "DELETE #destroy" do
    before { answer }
    let(:delete_request) { delete :destroy, question_id: question, id: answer }

    it "redirects to question show view" do
      delete_request
      expect(response).to redirect_to question_path(question)
    end

    it "deletes answer" do
      expect { delete_request }.to change(Answer, :count).by(-1)
    end

    it "assigns a success message to flash[:notice]" do
      delete_request
      expect(flash[:notice]).to eql "You have deleted the answer"
    end
  end
end
