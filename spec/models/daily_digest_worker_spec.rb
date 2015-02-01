require 'rails_helper'

RSpec.describe DailyDigestWorker, :type => :model do

  describe "#perform" do
    let(:users) { create_list(:user, 2) }

    it "creates a job for sending email to each user" do
      users.each { |user| expect(DailyDigestMailer).to receive(:digest).with(user.id).and_call_original }
      subject.perform
    end
  end
end