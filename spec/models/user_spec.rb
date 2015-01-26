require 'rails_helper'

RSpec.describe User, :type => :model do
  it { is_expected.to have_db_index(:username).unique(true) }
  it { is_expected.to validate_presence_of :username }
  it { is_expected.to validate_presence_of :email }
  it { is_expected.to validate_presence_of :password }
  it { is_expected.to have_many(:identities).dependent(:destroy) }
  it { is_expected.to have_many(:questions).dependent(:restrict_with_error) }
  it { is_expected.to have_many(:answers).dependent(:restrict_with_error) }

  describe ".find_for_oauth" do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: user.email, name: user.username }) }
    let(:find_for_oauth) { User.find_for_oauth(auth) }

    context "user already has identity" do
      before { user.identities.create!(provider: auth.provider, uid: auth.uid) }
      it "returns user" do
        expect(find_for_oauth).to eq user
      end
    end

    context "user does not have identity" do
      context "provider provides email (e.g. facebook)" do
        context "user already exists" do
          it "does not create a new user" do
            expect { find_for_oauth }.not_to change(User, :count)
          end

          it "creates user's identity" do
            expect { find_for_oauth }.to change(user.identities, :count).by(1)
          end

          it "creates user's identity with correct data" do
            identity = find_for_oauth.identities.first

            expect(identity.provider).to eq auth.provider
            expect(identity.uid).to eq auth.uid
          end

          it "returns user" do
            expect(find_for_oauth).to eq user
          end
        end

        context "new user" do
          let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: 'new@user.com', name: "New User" }) }
          it "creates user" do
            expect { find_for_oauth }.to change(User, :count).by(1)
          end

          it "returns created user" do
            expect(find_for_oauth).to be_a User
          end

          it "creates user with correct email" do
            expect(find_for_oauth.email).to eq auth.info[:email]
          end

          it "creates user's identity" do
            expect(find_for_oauth.identities).not_to be_empty
          end

          it "creates user's identity with correct data" do
            identity = find_for_oauth.identities.first

            expect(identity.provider).to eq auth.provider
            expect(identity.uid).to eq auth.uid
          end
        end
      end

      context "provider does not provide email (e.g. twitter)" do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'twitter', uid: '123456', info: { name: user.username }) }

        it "does not create a new user confirmation request" do
          expect { find_for_oauth }.not_to change(UserConfirmationRequest, :count)
        end

        it "returns nil" do
          expect(find_for_oauth).to be_nil
        end

        # context "user is requested for confirmation for the first time" do
        #   it "returns not saved user confirmation request" do
        #     expect(find_for_oauth).to be_a UserConfirmationRequest
        #   end
        #
        #   it "builds user confirmation request with correct data" do
        #     confirmation_request = find_for_oauth
        #
        #     expect(confirmation_request.provider).to eq auth.provider
        #     expect(confirmation_request.uid).to eq auth.uid
        #     expect(confirmation_request.username).to eq auth.name
        #   end
        # end
        #
        # context "user is requested for confirmation not for the first time" do
        #   let!(:confirmation) { create(:user_confirmation_request, provider: auth.provider, uid: auth.uid, username: user.username) }
        #
        #   it "returns user confirmation request" do
        #     expect(find_for_oauth).to eq confirmation
        #   end
        # end
      end
    end
  end
end
