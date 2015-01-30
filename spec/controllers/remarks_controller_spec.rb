require 'rails_helper'

RSpec.describe RemarksController, :type => :controller do
  before { @request.env["devise.mapping"] = Devise.mappings[:user] }

  let(:question) { create(:question) }
  let(:answer) { create(:answer) }
  let(:remark) { create(:remark, remarkable: question) }
  let(:old_remark) { attributes_for(:remark) }
  let(:new_remark) { attributes_for(:unique_remark) }
  let(:publishing_hash) { { "remark" => new_remark[:remark] } }

  describe "POST #create question's remark" do
    let(:do_request) { post :create, question_id: question, remark: new_remark, format: :json }

    context "(non-authenticated user)" do
      before { do_request }

      it { is_expected.to respond_with :unauthorized }
    end

    context "(authenticated user)" do
      sign_in_user

      context "with valid attributes" do
        it "responds with status CREATED" do
          do_request
          expect(response).to have_http_status(:created)
        end

        it "creates new remark in db" do
          expect { do_request }.to change(question.remarks, :count).by(1)
        end

        # FIRST VERSION
        it "publishes new remark" do
          allow(PrivatePub).to receive(:publish_to) do |path, hash|
            expect(path).to eq "/questions/#{question.id}"
            expect(hash[:remark]["remark"]).to eq new_remark[:remark]
            expect(hash[:remark]["user_id"]).to be_nil
            expect(hash[:remark]["author"]).to be_nil
          end
          allow(PrivatePub).to receive(:publish_to).with("/signed_in/questions/#{question.id}", hash_including(remark: hash_including("remark"=>new_remark[:remark], "user_id"=>@user.id, "author"=>@user.username)) )
          do_request
        end
        # FIRST VERSION

        # SECOND VERSION
        it "publishes new remark" do
          allow(PrivatePub).to receive(:publish_to).with("/questions/#{question.id}", hash_including(remark: hash_including("remark"=>new_remark[:remark])))
          allow(PrivatePub).to receive(:publish_to).with("/signed_in/questions/#{question.id}", hash_including(remark: hash_including("remark"=>new_remark[:remark], "user_id"=>@user.id, "author"=>@user.username)) )
          do_request
        end

        it "publishes new remark without author for unauthorized users" do
          allow(PrivatePub).to receive(:publish_to).with("/questions/#{question.id}", hash_including(remark: hash_excluding("user_id"=>@user.id, "author"=>@user.username)))
          allow(PrivatePub).to receive(:publish_to).with("/signed_in/questions/#{question.id}", hash_including(remark: hash_including("remark"=>new_remark[:remark], "user_id"=>@user.id, "author"=>@user.username)) )
          do_request
        end
        # SECOND VERSION

        it_behaves_like "a publisher on question page of", :remark
      end

      context "with invalid attributes" do
        let(:new_remark) { attributes_for(:invalid_remark) }

        it "responds with status UNPROCESSABLE ENTITY" do
          do_request
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it "does not create new remark in db" do
          question
          expect { do_request }.not_to change(Remark, :count)
        end
      end
    end
  end

  describe "POST #create answers's remark" do
    let(:question) { answer.question }
    let(:do_request) { post :create, answer_id: answer, remark: new_remark, format: :json }

    context "(non-authenticated user)" do
      before { do_request }

      it { is_expected.to respond_with :unauthorized }
    end

    context "(authenticated user)" do
      sign_in_user

      context "with valid attributes" do
        it "responds with status CREATED" do
          do_request
          expect(response).to have_http_status(:created)
        end

        it "creates new remark in db" do
          expect { do_request }.to change(answer.remarks, :count).by(1)
        end

        it_behaves_like "a publisher on question page of", :remark
      end

      context "with invalid attributes" do
        let(:new_remark) { attributes_for(:invalid_remark) }

        it "responds with status UNPROCESSABLE ENTITY" do
          do_request
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it "does not create new remark in db" do
          answer
          expect { do_request }.not_to change(Remark, :count)
        end
      end
    end
  end

  describe "PATCH #update" do
    let(:question) { answer.question }
    let(:do_request) { patch :update, id: remark, remark: new_remark, format: :json }

    context "(non-authenticated user)" do
      before { do_request }

      it "does not change remark in db" do
        remark.reload
        expect(remark.remark).to eq old_remark[:remark]
      end

      it { is_expected.to respond_with :unauthorized }
    end

    context "(authenticated user)" do
      sign_in_user

      context "another user's remark" do
        before { do_request }
        it "does not change remark in db" do
          remark.reload
          expect(remark.remark).to eq old_remark[:remark]
        end

        it { is_expected.to respond_with :forbidden }
      end

      context "current user's question remark" do
        let(:remark) { create(:remark, remarkable: question, user: @user) }

        context "with valid attributes" do
          it { do_request; is_expected.to respond_with(:ok) }

          it "updates remark in db" do
            do_request
            remark.reload
            expect(remark.remark).to eq new_remark[:remark]
          end

          it_behaves_like "a publisher on question page of", :remark
        end

        context "with invalid attributes" do
          before { do_request }
          let(:new_remark) { attributes_for(:invalid_remark) }

          it { is_expected.to respond_with(:unprocessable_entity) }

          it "does not change remark in db" do
            remark.reload
            expect(remark.remark).to eq old_remark[:remark]
          end
        end
      end

      context "current user's answer remark" do
        let(:remark) { create(:remark, remarkable: answer, user: @user) }

        context "with valid attributes" do
          it { do_request; is_expected.to respond_with(:ok) }

          it "updates remark in db" do
            do_request
            remark.reload
            expect(remark.remark).to eq new_remark[:remark]
          end

          it_behaves_like "a publisher on question page of", :remark
        end

        context "with invalid attributes" do
          let(:new_remark) { attributes_for(:invalid_remark) }
          before { do_request }

          it { is_expected.to respond_with(:unprocessable_entity) }

          it "does not change remark in db" do
            remark.reload
            expect(remark.remark).to eq old_remark[:remark]
          end
        end
      end
    end
  end

  describe "DELETE #destroy" do
    let(:do_request) { delete :destroy, id: remark, format: :json }
    let(:publishing_hash) { {} }

    context "(non-authenticated user)" do
      it "doesn't delete remark" do
        remark
        expect { do_request }.not_to change(Remark, :count)
      end

      it "returns Unauthorized status code" do
        do_request
        expect(response).to have_http_status :unauthorized
      end
    end

    context "(authenticated user)" do
      sign_in_user

      context "another user's remark" do
        it "doesn't delete remark" do
          remark
          expect { do_request }.not_to change(Remark, :count)
        end

        it "returns Forbidden status code" do
          do_request
          expect(response).to have_http_status :forbidden
        end
      end

      context "current user's question remark" do
        let(:remark) { create(:remark, remarkable: question, user: @user) }

        it { expect(response).to have_http_status :ok }

        it "deletes remark" do
          remark
          expect { do_request }.to change(Remark, :count).by(-1)
        end

        it_behaves_like "a publisher on question page of", :remark
      end

      context "current user's answer remark" do
        let(:remark) { create(:remark, remarkable: answer, user: @user) }

        it { expect(response).to have_http_status :ok }

        it "deletes remark" do
          remark
          expect { do_request }.to change(Remark, :count).by(-1)
        end
      end
    end
  end

end
