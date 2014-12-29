require 'rails_helper'

RSpec.describe AnswersController, :type => :controller do
  before { @request.env["devise.mapping"] = Devise.mappings[:user] }

  let(:question) { create(:question) }
  let(:answer) { create(:answer) }
  let(:old_answer) { attributes_for(:answer) }
  let(:new_answer) { attributes_for(:unique_answer) }

  describe "GET #new" do
    # before { get :new, question_id: question, format: :js }
    #
    # it "renders new template" do
    #   expect(response).to render_template :new
    # end
    #
    # it "populates requested question" do
    #   expect(assigns(:question)).to eq question
    # end
    #
    # it "assigns a new answer to @answer" do
    #   expect(assigns(:answer)).to be_a_new(Answer)
    # end
  end

  describe "GET #show" do
    # before { get :show, question_id: answer.question, id: answer, format: :js }
    #
    # it "renders show template" do
    #   expect(response).to render_template :edit
    # end
    #
    # it "populates requested question" do
    #   expect(assigns(:question)).to eq question
    # end
    #
    # it "assigns a new answer to @answer" do
    #   expect(assigns(:answer)).to eq answer
    # end
  end

  describe "POST #create" do
    let(:post_request) { post :create, question_id: question, answer: new_answer, format: :js }

    context "(non-authenticated user)" do
      before { post_request }

      it "returns Unauthorized status code" do
        expect(response).to have_http_status :unauthorized
      end
    end

    context "(authenticated user)" do
      sign_in_user

      context "with valid attributes" do
        it "renders create template" do
          post_request
          expect(response).to render_template :create
        end

        it "creates new answer in db" do
          expect { post_request }.to change(question.answers, :count).by(1)
        end

        it "assigns all answers for this question to @answers" do
          post_request
          expect(assigns(:answers)).to match_array(question.answers)
        end

        it "assigns a new answer to @answer" do
          post_request
          expect(assigns(:answer)).to be_a_new(Answer)
        end

        it "assigns false to @editable" do
          expect(assigns(:editable)).to be_falsey
        end
      end

      context "with invalid attributes" do
        let(:new_answer) { attributes_for(:invalid_answer) }

        it "renders create template" do
          post_request
          expect(response).to render_template :create
        end

        it "does not create new answer in db" do
          expect { post_request }.not_to change(Answer, :count)
        end

        it "assigns an error message to @errors" do
          post_request
          expect(assigns(:errors)).to eq ["Answer can't be blank"]
        end
      end
    end

  end

  describe "PATCH #update" do
    let(:patch_request) { patch :update, question_id: answer.question, id: answer, answer: new_answer, format: :js }

    context "(non-authenticated user)" do
      before { patch_request }

      it "does not change answer in db" do
        answer.reload
        expect(answer.answer).to eq old_answer[:answer]
      end

      it "returns Unauthorized status code" do
        expect(response).to have_http_status :unauthorized
      end
    end

    context "(authenticated user)" do
      sign_in_user
      before { patch_request }

      context "another user's answer" do
        it "does not change answer in db" do
          answer.reload
          expect(answer.answer).to eq old_answer[:answer]
        end

        it "returns Forbidden status code" do
          expect(response).to have_http_status :forbidden
        end
      end

      context "current user's answer" do
        let(:answer) { create(:answer, user: @user) }

        it 'renders update view' do
          expect(response).to render_template :update
        end

        context "with valid attributes" do
          it "updates answer in db" do
            answer.reload
            expect(answer.answer).to eq new_answer[:answer]
          end

          it "assigns the question to @question" do
            expect(assigns(:question)).to eq answer.question
          end

          it "assigns all answers for this question to @answers" do
            expect(assigns(:answers)).to match_array(answer.question.answers)
          end

          it "assigns a success message to flash[:notice]" do
            expect(flash[:notice]).to eql "You have updated the answer"
          end
        end

        context "with invalid attributes" do
          let(:new_answer) { attributes_for(:invalid_answer) }

          it "does not change answer in db" do
            answer.reload
            expect(answer.answer).to eq old_answer[:answer]
          end

          it "assigns an error message to @errors" do
            expect(assigns(:errors)).to eq ["Answer can't be blank"]
          end
        end
      end
    end
  end

  describe "DELETE #destroy" do
    let(:delete_request) { delete :destroy, question_id: answer.question, id: answer, format: :js }

    context "(non-authenticated user)" do
      it "doesn't delete answer" do
        answer
        expect { delete_request }.not_to change(Answer, :count)
      end

      it "returns Unauthorized status code" do
        delete_request
        expect(response).to have_http_status :unauthorized
      end
    end

    context "(authenticated user)" do
      sign_in_user

      context "another user's answer" do
        it "doesn't delete answer" do
          answer
          expect { delete_request }.not_to change(Answer, :count)
        end

        it "returns Forbidden status code" do
          delete_request
          expect(response).to have_http_status :forbidden
        end
      end

      context "current user's answer" do
        let(:answer) { create(:answer, user: @user) }

        it 'renders delete view' do
          delete_request
          expect(response).to render_template :destroy
        end

        it "deletes answer" do
          answer
          expect { delete_request }.to change(Answer, :count).by(-1)
        end

        it "assigns deleted answer's id to @id" do
          delete_request
          expect(assigns(:id)).to eq answer.id
        end

        it "assigns true to @editable" do
          delete_request
          expect(assigns(:editable)).to be_truthy
        end

        it "assigns nil to @answer.id" do
          delete_request
          expect(assigns(:answer).id).to be_nil
        end

        it "assigns a success message to flash[:notice]" do
          delete_request
          expect(flash[:notice]).to eql "You have deleted the answer"
        end
      end
    end
  end
end
