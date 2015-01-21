require 'rails_helper'

RSpec.describe UserConfirmationRequest, :type => :model do
  it { is_expected.to validate_presence_of :provider }
  it { is_expected.to validate_presence_of :uid }
  it { is_expected.to validate_presence_of :email }
  it { is_expected.to validate_presence_of :username }
  it { is_expected.to have_db_index([:provider, :uid]).unique }

  let(:user_confirmation_request) { create(:user_confirmation_request) }

  context "before save" do
    it "generates confirmation_token" do
      expect(user_confirmation_request.confirmation_token).not_to be_nil
    end

    it "generates confirmation_token each time" do
      confirmation_token = user_confirmation_request
      user_confirmation_request.update!(username: 'AAA')

      expect(user_confirmation_request.confirmation_token).not_to eq confirmation_token
    end
  end

  context "after save" do
    it "sends an email" do
      expect { user_confirmation_request }.to change(ActionMailer::Base.deliveries, :count).by(1)
    end
  end

  describe "#create_or_attach_user" do
    context "user already exists" do
      let!(:user) { create(:user, email: user_confirmation_request.email) }

      it "does not create a new user" do
        expect { user_confirmation_request.create_or_attach_user }.not_to change(User, :count)
      end

      it "returns user" do
        expect(user_confirmation_request.create_or_attach_user).to eq user
      end

      it "updates user name" do
        expect(user_confirmation_request.create_or_attach_user.username).to eq user_confirmation_request.username
      end

      it "creates user identity" do
        expect { user_confirmation_request.create_or_attach_user }.to change(user.identities, :count).by(1)
      end

      it "creates user identity with correct data" do
        identity = user_confirmation_request.create_or_attach_user.identities.first

        expect(identity.provider).to eq user_confirmation_request.provider
        expect(identity.uid).to eq user_confirmation_request.uid
      end

      it "deletes itself" do
        expect { user_confirmation_request.create_or_attach_user }.to change(UserConfirmationRequest, :count).by(-1)
      end
    end

    context "new user" do
      it "creates user" do
        expect { user_confirmation_request.create_or_attach_user }.to change(User, :count).by(1)
      end

      it "returns user" do
        expect(user_confirmation_request.create_or_attach_user).to be_a User
      end

      it "creates user with correct data" do
        user = user_confirmation_request.create_or_attach_user

        expect(user.username).to eq user_confirmation_request.username
        expect(user.email).to eq user_confirmation_request.email
      end

      it "creates user identity" do
        expect { user_confirmation_request.create_or_attach_user }.to change(Identity, :count).by(1)
      end

      it "creates user identity with correct data" do
        identity = user_confirmation_request.create_or_attach_user.identities.first

        expect(identity.provider).to eq user_confirmation_request.provider
        expect(identity.uid).to eq user_confirmation_request.uid
      end

      it "deletes itself" do
        user_confirmation_request
        expect { user_confirmation_request.create_or_attach_user }.to change(UserConfirmationRequest, :count).by(-1)
      end
    end
  end
end
