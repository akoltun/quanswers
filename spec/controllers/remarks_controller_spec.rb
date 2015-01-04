require 'rails_helper'

RSpec.describe RemarksController, :type => :controller do
  before { @request.env["devise.mapping"] = Devise.mappings[:user] }

  let(:remark) { create(:remark) }
  let(:question) { remark.question }
  let(:old_remark) { attributes_for(:remark) }
  let(:new_remark) { attributes_for(:unique_remark) }

  describe "POST #create" do
    let(:post_request) { post :create, question_id: question, remark: new_remark, format: :json }

    context "(non-authenticated user)" do
      before { post_request }

      it { is_expected.to respond_with :unauthorized }
    end

    context "(authenticated user)" do
      sign_in_user

      context "with valid attributes" do
        it "responds with status CREATED" do
          post_request
          expect(response).to have_http_status(:created)
        end

        it "renders show view" do
          post_request
          expect(response).to render_template :show
        end

        it "creates new remark in db" do
          expect { post_request }.to change(question.remarks, :count).by(1)
        end

        it "assigns created remark to @remark" do
          post_request
          expect(assigns(:remark)).to eq question.remarks.last
        end
      end

      context "with invalid attributes" do
        let(:new_remark) { attributes_for(:invalid_remark) }

        it "responds with status UNPROCESSABLE ENTITY" do
          post_request
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it "renders error view" do
          post_request
          expect(response).to render_template :error
        end

        it "does not create new remark in db" do
          question
          expect { post_request }.not_to change(Remark, :count)
        end

        it "assigns an error message to @errors" do
          post_request
          expect(assigns(:errors)).to match_array ["Remark can't be blank"]
        end
      end
    end
  end

  describe "PATCH #update" do
    let(:patch_request) { patch :update, id: remark, remark: new_remark, format: :json }

    context "(non-authenticated user)" do
      before { patch_request }

      it "does not change remark in db" do
        remark.reload
        expect(remark.remark).to eq old_remark[:remark]
      end

      it { is_expected.to respond_with :unauthorized }
    end

    context "(authenticated user)" do
      sign_in_user
      before { patch_request }

      context "another user's remark" do
        it "does not change remark in db" do
          remark.reload
          expect(remark.remark).to eq old_remark[:remark]
        end

        it { is_expected.to respond_with :forbidden }
      end

      context "current user's remark" do
        let(:remark) { create(:remark, user: @user) }

        context "with valid attributes" do
          it { is_expected.to respond_with(:ok) }

          it 'renders show view' do
            expect(response).to render_template :show
          end

          it "updates remark in db" do
            remark.reload
            expect(remark.remark).to eq new_remark[:remark]
          end

          it "assigns updated remark to @remark" do
            remark.reload
            expect(assigns(:remark)).to eq remark
          end
        end

        context "with invalid attributes" do
          let(:new_remark) { attributes_for(:invalid_remark) }

          it { is_expected.to respond_with(:unprocessable_entity) }

          it 'renders error view' do
            expect(response).to render_template :error
          end

          it "does not change remark in db" do
            remark.reload
            expect(remark.remark).to eq old_remark[:remark]
          end

          it "assigns an error message to @errors" do
            expect(assigns(:errors)).to match_array ["Remark can't be blank"]
          end
        end
      end
    end
  end

  describe "DELETE #destroy" do
    let(:delete_request) { delete :destroy, id: remark, format: :json }

    context "(non-authenticated user)" do
      it "doesn't delete remark" do
        remark
        expect { delete_request }.not_to change(Remark, :count)
      end

      it "returns Unauthorized status code" do
        delete_request
        expect(response).to have_http_status :unauthorized
      end
    end

    context "(authenticated user)" do
      sign_in_user

      context "another user's remark" do
        it "doesn't delete remark" do
          remark
          expect { delete_request }.not_to change(Remark, :count)
        end

        it "returns Forbidden status code" do
          delete_request
          expect(response).to have_http_status :forbidden
        end
      end

      context "current user's remark" do
        let(:remark) { create(:remark, user: @user) }

        it { expect(response).to have_http_status :ok }

        it "deletes answer" do
          remark
          expect { delete_request }.to change(Remark, :count).by(-1)
        end
      end
    end
  end

end
