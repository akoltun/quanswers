require 'rails_helper'

RSpec.describe QuestionsController, :type => :controller do
  before { @request.env["devise.mapping"] = Devise.mappings[:user] }

  let(:question) { create(:question) }

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
    let(:show_request) { get :show, id: question }

    context "(both authenticated and non-authenticated users)" do
      let(:question) { create(:question_with_answers) }
      before { show_request }

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
    end
  end

  describe "GET #show via AJAX" do
    let(:show_request) { xhr :get, :show, id: question, format: :js }

    context "(both authenticated and non-authenticated users)" do
      let(:question) { create(:question_with_answers) }
      before { show_request }

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
    end
  end

  describe "GET #new" do
    sign_in_user
    before { get :new }

    it "renders new view" do
      expect(response).to render_template :new
    end

    it "populates a new question" do
      expect(assigns(:question)).to be_a_new(Question)
    end
  end

  describe "POST #create" do
    let(:post_request) { post :create, question: attributes_for(:question) }

    context "(authenticated user)" do
      sign_in_user

      context "with valid attributes" do
        it "creates new question in db" do
          expect { post_request }.to change(Question, :count).by(1)
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
      end
    end

    context "(non-authenticated user)" do
      before { post_request }

      it "redirects to sign in page" do
        expect(response).to redirect_to new_user_session_path
      end

      it { is_expected.to set_the_flash[:alert].to("You need to sign in or sign up before continuing.") }
    end
  end

  describe "PATCH #update" do
    let(:update_hash) { attributes_for(:another_question) }
    let(:question_hash) { attributes_for(:question) }
    let(:patch_request) { patch :update, id: question, question: update_hash, format: :js }

    context "(authenticated user)" do
      sign_in_user
      before { patch_request }

      context "this user's question without answers with valid attributes" do
        let(:question) { create(:question, user: @user) }

        it "renders show view" do
          expect(response).to render_template :show
        end

        it "updates question in db" do
          question.reload
          expect(question.title).to eq update_hash[:title]
          expect(question.question).to eq update_hash[:question]
        end

        it "assigns requested question to @question" do
          expect(assigns(:question)).to eq question
        end

        it "assigns an array of all answers for this question" do
          expect(assigns(:answers)).to match_array(question.answers)
        end

        it "assigns a new answer to @answer" do
          expect(assigns(:answer)).to be_a_new(Answer)
        end

        it { is_expected.to set_the_flash[:notice].to("You have updated the Question").now }
      end

      context "this user's question without answers with invalid attributes" do
        let(:question) { create(:question, user: @user) }
        let(:update_hash) { attributes_for(:invalid_question) }

        it "renders show view" do
          expect(response).to render_template :show
        end

        it "does not change question in db" do
          question.reload
          expect(question.title).to eq question_hash[:title]
          expect(question.question).to eq question_hash[:question]
        end

        it "assigns an array of all answers for this question" do
          expect(assigns(:answers)).to match_array(question.answers)
        end
      end

      context "question with answers" do
        let(:question) { create(:question_with_answers, user: @user) }

        it { is_expected.to respond_with 403 }

        it "does not change question in db" do
          question.reload
          expect(question.title).to eq question_hash[:title]
          expect(question.question).to eq question_hash[:question]
        end
      end

      context "another user's question" do
        it { is_expected.to respond_with 403 }

        it "does not change question in db" do
          question.reload
          expect(question.title).to eq question_hash[:title]
          expect(question.question).to eq question_hash[:question]
        end
      end
    end

    context "(non-authenticated user)" do
      before { patch_request }

      it { is_expected.to respond_with :unauthorized }
    end
  end

  describe "DELETE #destroy" do
    let(:delete_request) { delete :destroy, id: question }

    context "(authenticated user)" do
      sign_in_user
      before { question }

      context "this user's question without answers" do
        let(:question) { create(:question, user: @user) }

        it "redirects to index view" do
          delete_request
          expect(response).to redirect_to questions_path
        end

        it "deletes question" do
          expect { delete_request }.to change(Question, :count).by(-1)
        end
      end

      context "this user's question with answers" do
        let(:question) { create(:question_with_answers, user: @user) }

        it "redirects to root" do
          delete_request
          expect(response).to redirect_to root_url
        end

        it "does not delete question from db" do
          expect { delete_request }.not_to change(Question, :count)
        end
      end

      context "another user's question" do
        it "redirects to root" do
          delete_request
          expect(response).to redirect_to root_path
        end

        it "does not delete question from db" do
          expect { delete_request }.not_to change(Question, :count)
        end
      end
    end

    context "(non-authenticated user)" do
      before { delete_request }

      it "redirects to sign in page" do
        expect(response).to redirect_to new_user_session_path
      end

      it { is_expected.to set_the_flash[:alert].to("You need to sign in or sign up before continuing.") }
    end
  end
end