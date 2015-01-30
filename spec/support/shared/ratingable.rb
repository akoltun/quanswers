RSpec.shared_examples "a ratingable" do
  describe "#rating" do
    context "when there are no ratings" do
      it "returns nil" do
        expect(subject.rating).to be_nil
      end
    end
  end

  describe "#rating!" do
    let(:user) { create(:user) }
    context "when there was rating created by another user" do
      let!(:rating) { create(:rating, ratingable: subject, rating: 2) }

      it "creates new rating in database" do
        expect { subject.rating!(user, 3) }.to change(subject.ratings, :count).by(1)
      end
      it "creates rating with correct value" do
        subject.rating!(user, 3)
        expect(subject.ratings.last.rating).to eq 3
      end
      it "subject.rating returns average rating" do
        subject.rating!(user, 3)
        expect(subject.rating).to eq 2.5
      end
    end
    context "when there was rating already" do
      let!(:rating) { create(:rating, ratingable: subject, user: user, rating: 2) }

      it "does not create new rating in database" do
        expect { subject.rating!(user, 3) }.not_to change(Rating, :count)
      end

      it "updates rating in database" do
        subject.rating!(user, 3)
        rating.reload
        expect(rating.rating).to eq 3
      end
      it "subject.rating returns average rating" do
        subject.rating!(user, 3)
        expect(subject.rating).to eq 3
      end
    end
    context "when there was not rating yet" do
      it "creates new rating in database" do
        expect { subject.rating!(user, 3) }.to change(subject.ratings, :count).by(1)
      end
      it "creates rating with correct value" do
        subject.rating!(user, 3)
        expect(subject.ratings.first.rating).to eq 3
      end
      it "subject.rating returns average rating" do
        subject.rating!(user, 3)
        expect(subject.rating).to eq 3
      end
    end
  end
end