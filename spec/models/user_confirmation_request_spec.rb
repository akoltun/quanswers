require 'rails_helper'

RSpec.describe UserConfirmationRequest, :type => :model do
  it { is_expected.to validate_presence_of :provider }
  it { is_expected.to validate_presence_of :uid }
  it { is_expected.to validate_presence_of :email }
  it { is_expected.to validate_presence_of :username }
  it { is_expected.to have_db_index([:provider, :uid]).unique }

  let(:user_confirmation_request) { create(:user_confirmation_request) }

  describe "#update_and_send_confirmation_request" do
    let(:update_and_send_request) do
      user_confirmation_request.update_and_send_request(email: 'new@email.com', username: 'new name')
      user_confirmation_request.reload
    end

    it "updates email" do
      update_and_send_request
      expect(user_confirmation_request.email).to eq 'new@email.com'
    end

    it "updates username" do
      update_and_send_request
      expect(user_confirmation_request.username).to eq 'new name'
    end

    it "generates confirmation_token" do
      update_and_send_request
      expect(user_confirmation_request.confirmation_token).not_to be_nil
    end

    it "generates confirmation_token each time" do
      expect { update_and_send_request }.to change(user_confirmation_request, :confirmation_token)
    end

    it "sends an email" do
      expect { update_and_send_request }.to change(ActionMailer::Base.deliveries, :count).by(1)
    end
  end

  describe "#session_alive?" do
    context "for sessions created more then 1 hour before" do
      before { user_confirmation_request.request_session_created_at = Time.current - 60*60 }
      it { expect(user_confirmation_request.session_alive?).to be_falsey }
    end

    context "for sessions created less then 1 hour before" do
      before { user_confirmation_request.request_session_created_at = Time.current - 60*60 + 1 }
      it { expect(user_confirmation_request.session_alive?).to be_truthy }
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

  describe ".find_for_oauth" do
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }
    let(:find_for_oauth) { UserConfirmationRequest.find_for_oauth(auth) }

    context "user confirmation request already exists" do
      let!(:user_confirmation_request) { create(:user_confirmation_request, provider: auth.provider, uid: auth.uid) }

      it "does not create new UserConfirmationRequest" do
        expect { find_for_oauth }.not_to change(UserConfirmationRequest, :count)
      end

      it "returns user confirmation request" do
        expect(find_for_oauth).to eq user_confirmation_request
      end

      it "sets #request_session_created_at to current time" do
        expect { find_for_oauth; user_confirmation_request.reload }.to change(user_confirmation_request, :request_session_created_at)
      end
    end

    context "user confirmation request does not exist" do
      it "creates new UserConfirmationRequest" do
        expect { find_for_oauth }.to change(UserConfirmationRequest, :count).by(1)
      end

      it "returns created user confirmation request" do
        expect(find_for_oauth).to be_a UserConfirmationRequest
      end

      it "creates user confirmation request with correct data" do
        user_confirmation_request = find_for_oauth

        expect(user_confirmation_request.provider).to eq auth.provider
        expect(user_confirmation_request.uid).to eq auth.uid
      end
    end
  end
end
