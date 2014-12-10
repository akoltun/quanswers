require 'rails_helper'

RSpec.describe QuestionsController, :type => :controller do
  let(:question) { create(:question) }

  describe "GET #index" do
    let(:questions) { create_list(:question, 2) }
    before { get :index }

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "renders index view" do
      expect(response).to render_template :index
    end

    it "populates an array of all questions" do
      expect(assigns(:questions)).to match_array(questions)
    end
  end

  describe "GET #show" do
    before { get :show, id: question }

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "renders show view" do
      expect(response).to render_template :show
    end

    it "populates requested question" do
      expect(assigns(:question)).to eq question
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
      it "redirects to show view" do
        post :create, question: attributes_for(:question)
        expect(response).to redirect_to question_path(assigns(:question))
      end

      it "creates new question in db" do
        expect { post :create, question: attributes_for(:question) }.to change(Question, :count).by(1)
      end
    end

    context "with invalid attributes" do
      it "re-renders new view" do
        post :create, question: attributes_for(:invalid_question)
        expect(response).to render_template :new
      end

      it "does not create new question in db" do
        expect { post :create, question: attributes_for(:invalid_question) }.not_to change(Question, :count)
      end
    end
  end

  describe "PATCH #update" do
    before { patch :update, id: question, question: update_hash }

    context "with valid attributes" do
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
    end

    context "with invalid attributes" do
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
    end
  end

  describe "DELETE #destroy" do
    before { question }

    it "redirects to index view" do
      delete :destroy, id: question
      expect(response).to redirect_to question_path
    end

    it "deletes question" do
      expect { delete :destroy, id: question }.to change(Question, :count).by(-1)
    end
  end

end
