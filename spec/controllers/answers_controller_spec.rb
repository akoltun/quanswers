require 'rails_helper'

RSpec.describe AnswersController, :type => :controller do
  before { @request.env["devise.mapping"] = Devise.mappings[:user] }

  let(:answer) { create(:answer) }
  let(:question) { answer.question }
  let(:old_answer) { attributes_for(:answer) }
  let(:new_answer) { attributes_for(:unique_answer) }

  describe "POST #create" do
    let(:post_request) { post :create, question_id: question, answer: new_answer, format: :js }

    context "(non-authenticated user)" do
      before { post_request }

      it { is_expected.to respond_with :unauthorized }
    end

    context "(authenticated user)" do
      sign_in_user

      context "with valid attributes" do
        it "creates new answer in db" do
          expect { post_request }.to change(question.answers, :count).by(1)
        end
      end

      context "with invalid attributes" do
        let(:new_answer) { attributes_for(:invalid_answer) }

        it "responds with Unprocessable Entity" do
          post_request
          expect(response).to have_http_status :unprocessable_entity
        end

        it "does not create new answer in db" do
          question
          expect { post_request }.not_to change(Answer, :count)
        end
      end
    end
  end

  describe "PATCH #update" do
    let(:patch_request) { patch :update, question_id: question, id: answer, answer: new_answer, format: :js }

    context "(non-authenticated user)" do
      before { patch_request }

      it "does not change answer in db" do
        answer.reload
        expect(answer.answer).to eq old_answer[:answer]
      end

      it { is_expected.to respond_with :unauthorized }
    end

    context "(authenticated user)" do
      sign_in_user
      before { patch_request }

      context "another user's answer" do
        it "does not change answer in db" do
          answer.reload
          expect(answer.answer).to eq old_answer[:answer]
        end

        it { is_expected.to respond_with :forbidden }
      end

      context "current user's answer" do
        let(:answer) { create(:answer, user: @user) }

        context "with valid attributes" do
          it "updates answer in db" do
            answer.reload
            expect(answer.answer).to eq new_answer[:answer]
          end
        end

        context "with invalid attributes" do
          let(:new_answer) { attributes_for(:invalid_answer) }

          it "does not change answer in db" do
            answer.reload
            expect(answer.answer).to eq old_answer[:answer]
          end

          it { is_expected.to respond_with :unprocessable_entity }
        end
      end
    end
  end

  describe "DELETE #destroy" do
    let(:delete_request) { delete :destroy, question_id: question, id: answer, format: :js }

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

        it "deletes answer" do
          answer
          expect { delete_request }.to change(Answer, :count).by(-1)
        end
      end
    end
  end

  describe "PATCH #best" do
    let(:question) { create(:question) }
    let(:answer) { create(:answer, question: question) }
    let(:best_request) { patch :set_as_best, id: answer, format: :js }

    context "(authenticated user)" do
      sign_in_user
      before { best_request }

      context "this user's question" do
        let(:question) { create(:question, user: @user) }

        it "sets answer as best" do
          question.reload
          expect(question.best_answer).to eq answer
        end

        it "response with OK status code" do
          expect(response).to have_http_status :ok
        end
      end

      context "another user's question" do
        it "doesn't set answer as best" do
          expect(question.best_answer).to be_nil
        end

        it "response with FORBIDDEN status code" do
          expect(response).to have_http_status :forbidden
        end
      end
    end

    context "(non-authenticated user)" do
      before { best_request }

      it "doesn't set answer as best" do
        expect(question.best_answer).to be_nil
      end

      it { is_expected.to respond_with :unauthorized }
    end
  end
end
