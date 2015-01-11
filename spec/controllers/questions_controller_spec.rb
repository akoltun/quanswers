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

    context "(authenticated user)" do
      sign_in_user
      before { show_request }

      context "for another user's question" do
        it "assigns false to @author_signed_in" do
          expect(assigns(:author_signed_in)).to be_falsey
        end
      end

      context "for this user's question without answers" do
        let(:question) { create(:question, user: @user) }

        it "assigns true to @author_signed_in" do
          expect(assigns(:author_signed_in)).to be_truthy
        end
      end
    end

    context "(non-authenticated user)" do
      before { show_request }

      it "assigns false to @author_signed_in" do
        expect(assigns(:author_signed_in)).to be_falsey
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

    context "(authenticated user)" do
      sign_in_user
      before { show_request }

      context "for another user's question" do
        it "assigns false to @author_signed_in" do
          expect(assigns(:author_signed_in)).to be_falsey
        end
      end

      context "for this user's question without answers" do
        let(:question) { create(:question, user: @user) }

        it "assigns true to @author_signed_in" do
          expect(assigns(:author_signed_in)).to be_truthy
        end
      end
    end

    context "(non-authenticated user)" do
      before { show_request }

      it "assigns false to @author_signed_in" do
        expect(assigns(:author_signed_in)).to be_falsey
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
    let(:patch_request) { patch :update, id: question, question: update_hash }

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

        it "assigns false to @author_signed_in" do
          expect(assigns(:author_signed_in)).to be_truthy
        end

        it { is_expected.to set_the_flash[:notice].to("You have updated the question").now }
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

        it "assigns false to @author_signed_in" do
          expect(assigns(:author_signed_in)).to be_truthy
        end
      end

      context "question with answers" do
        let(:question) { create(:question_with_answers, user: @user) }

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

        it "assigns false to @author_signed_in" do
          expect(assigns(:author_signed_in)).to be_truthy
        end

        it { is_expected.to set_the_flash[:alert].to("Can't update question which already has answers").now }
      end

      context "another user's question" do
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

        it "assigns false to @author_signed_in" do
          expect(assigns(:author_signed_in)).to be_falsey
        end

        it { is_expected.to set_the_flash[:alert].to("Can't update another user's question").now }
      end
    end

    context "(non-authenticated user)" do
      before { patch_request }

      it "redirects to sign in page" do
        expect(response).to redirect_to new_user_session_path
      end

      it "assigns false to @author_signed_in" do
        expect(assigns(:author_signed_in)).to be_falsey
      end

      it { is_expected.to set_the_flash[:alert].to("You need to sign in or sign up before continuing.") }
    end
  end

  describe "DELETE #destroy" do
    let(:delete_request) { delete :destroy, id: question }

    context "(authenticated user)" do
      sign_in_user
      before { question }

      context "this user's question without answers" do
        let(:question) { create(:question, user: @user) }

        it "assigns false to @author_signed_in" do
          delete_request
          expect(assigns(:author_signed_in)).to be_truthy
        end

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

      context "this user's question with answers" do
        let(:question) { create(:question_with_answers, user: @user) }

        it "assigns false to @author_signed_in" do
          delete_request
          expect(assigns(:author_signed_in)).to be_truthy
        end

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

      context "another user's question" do
        it "redirects to show view" do
          delete_request
          expect(response).to redirect_to question_path(question)
        end

        it "does not delete question from db" do
          expect { delete_request }.not_to change(Question, :count)
        end

        it "assigns false to @author_signed_in" do
          delete_request
          expect(assigns(:author_signed_in)).to be_falsey
        end

        it "assigns an error message to flash[:alert]" do
          delete_request
          expect(flash[:alert]).to eql "Can't delete another user's question"
        end
      end
    end

    context "(non-authenticated user)" do
      before { delete_request }

      it "redirects to sign in page" do
        expect(response).to redirect_to new_user_session_path
      end

      it "assigns false to @author_signed_in" do
        expect(assigns(:author_signed_in)).to be_falsey
      end

      it { is_expected.to set_the_flash[:alert].to("You need to sign in or sign up before continuing.") }
    end
  end
end