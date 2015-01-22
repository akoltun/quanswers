require 'rails_helper'

RSpec.shared_examples "a ratingable" do
  describe "#rating" do
    context "when there are ratings" do
      before do
        create(:rating, ratingable: subject, rating: 2)
        create(:rating, ratingable: subject, rating: 3)
      end
      it "returns average rating" do
        expect(subject.rating).to eq 2.5
      end
    end

    context "when there are no ratings" do
      it "returns nil" do
        expect(subject.rating).to be_nil
      end
    end
  end
end