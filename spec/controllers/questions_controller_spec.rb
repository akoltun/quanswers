require 'rails_helper'

RSpec.describe QuestionsController, :type => :controller do
  let(:question) { create(:question_with_answers) }

  describe "GET #index" do
    let(:questions) { create_list(:question_with_answers, 2) }
    before { get :index }

    it "renders index view" do
      expect(response).to render_template :index
    end

    it "populates an array of all questions" do
      expect(assigns(:questions)).to match_array(questions)
    end
  end

  describe "GET #show" do
    before { get :show, id: question }

    it "renders show view" do
      expect(response).to render_template :show
    end

    it "populates requested question" do
      expect(assigns(:question)).to eq question
    end

    it "populates an array of all answers for this question" do
      expect(assigns(:answers)).to match_array(question.answers)
    end

    it "populates a new answer" do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it "assigns false to @editable" do
      expect(assigns(:editable)).to be_falsey
    end

    context "for question without answers" do
      let(:question) { create(:question) }

      it "assigns true to @editable" do
        expect(assigns(:editable)).to be_truthy
      end
    end
  end

  describe "GET #new" do
    before { get :new }

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "renders new view" do
      expect(response).to render_template :new
    end

    it "populates a new question" do
      expect(assigns(:question)).to be_a_new(Question)
    end
  end

  describe "GET #edit" do
    before { get :edit, id: question}

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "renders edit view" do
      expect(response).to render_template :edit
    end

    it "populates requested question" do
      expect(assigns(:question)).to eql question
    end
  end

  describe "POST #create" do
    context "with valid attributes" do
      let(:post_request) { post :create, question: attributes_for(:question) }

      it "redirects to show view" do
        post_request
        expect(response).to redirect_to questions_path
      end

      it "creates new question in db" do
        expect { post_request }.to change(Question, :count).by(1)
      end

      it "assigns a success message to flash[:notice]" do
        post_request
        expect(flash[:notice]).to eql "You have created a new question"
      end
    end

    context "with invalid attributes" do
      let(:post_request) { post :create, question: attributes_for(:invalid_question) }

      it "re-renders new view" do
        post_request
        expect(response).to render_template :new
      end

      it "does not create new question in db" do
        expect { post_request }.not_to change(Question, :count)
      end

      it "assigns an error message to flash[:alert]" do
        post_request
        expect(flash[:alert]).to eql ["Title can't be blank"]
      end
    end
  end

  describe "PATCH #update" do
    before { patch :update, id: question, question: update_hash }

    context "question without answers with valid attributes" do
      let(:question) { create(:question) }
      let(:update_hash) { attributes_for(:another_question) }

      it "redirects to show view" do
        expect(response).to redirect_to question
      end

      it "updates question in db" do
        question.reload
        expect(question.title).to eq update_hash[:title]
        expect(question.question).to eq update_hash[:question]
      end

      it "assigns requested question to @question" do
        expect(assigns(:question)).to eq question
      end

      it "assigns a success message to flash[:notice]" do
        expect(flash[:notice]).to eql "You have updated the question"
      end
    end

    context "question without answers with invalid attributes" do
      let(:question) { create(:question) }
      let(:update_hash) { attributes_for(:invalid_question) }
      let(:question_hash) { attributes_for(:question) }

      it 're-renders edit view' do
        expect(response).to render_template :edit
      end

      it "does not change question in db" do
        question.reload
        expect(question.title).to eq question_hash[:title]
        expect(question.question).to eq question_hash[:question]
      end

      it "assigns an error message to flash[:alert]" do
        expect(flash[:alert]).to eql ["Title can't be blank"]
      end
    end

    context "question with answers" do
      let(:update_hash) { attributes_for(:another_question) }
      let(:question_hash) { attributes_for(:question) }

      it "redirects to show view" do
        expect(response).to redirect_to question_path(question)
      end

      it "does not change question in db" do
        question.reload
        expect(question.title).to eq question_hash[:title]
        expect(question.question).to eq question_hash[:question]
      end

      it "assigns an error message to flash[:alert]" do
        expect(flash[:alert]).to eql "Can't edit question which already has answers"
      end
    end
  end

  describe "DELETE #destroy" do
    before { question }
    let(:delete_request) { delete :destroy, id: question }

    context "question without answers" do
      let(:question) { create(:question) }

      it "redirects to index view" do
        delete_request
        expect(response).to redirect_to questions_path
      end

      it "deletes question" do
        expect { delete_request }.to change(Question, :count).by(-1)
      end

      it "assigns a success message to flash[:notice]" do
        delete_request
        expect(flash[:notice]).to eql "You have deleted the question"
      end
    end

    context "question with answers" do
      it "redirects to show view" do
        delete_request
        expect(response).to redirect_to question_path(question)
      end

      it "does not delete question from db" do
        expect { delete_request }.not_to change(Question, :count)
      end

      it "assigns an error message to flash[:alert]" do
        delete_request
        expect(flash[:alert]).to eql "Can't delete question which already has answers"
      end
    end
  end

end
