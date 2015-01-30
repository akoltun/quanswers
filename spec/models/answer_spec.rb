require 'rails_helper'

RSpec.describe Answer, :type => :model do

  it { is_expected.to validate_presence_of(:user) }
  it { is_expected.to validate_presence_of(:question) }
  it { is_expected.to validate_presence_of(:answer) }

  it { is_expected.to ensure_length_of(:answer).is_at_most(2000) }

  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:question) }
  it { is_expected.to have_many(:remarks) }
  it { is_expected.to have_many(:ratings).dependent(:destroy) }
  it { is_expected.to have_many(:attachments).dependent(:destroy) }
  it { is_expected.to accept_nested_attributes_for :attachments }

  it { is_expected.to have_db_index(:user_id).unique(false) }
  it { is_expected.to have_db_index(:question_id).unique(false) }

  let(:answer) { create(:answer) }
  context "when it is not the best answer #best?" do
    it { expect(answer.best?).to be_falsey }
  end

  context "when it is the best answer #best?" do
    before { answer.question.update!(best_answer: answer) }
    it { expect(answer.best?).to be_truthy }
  end

  describe "#best! method" do
    before { answer.best! }
    it "should set it as the best answer" do
      expect(answer.question.best_answer).to eq answer
    end
  end

  context "when destroy best answer" do
    before do
      answer.best!
      answer.destroy!
    end
    it "nils question #best_answer" do
      expect(answer.question.best_answer).to be_nil
    end
  end

  context "when destroy not best answer" do
    before do
      create(:unique_answer, question: answer.question).best!
      answer.question.save!
      answer.destroy!
    end
    it "nils question #best_answer" do
      expect(answer.question.best_answer).not_to be_nil
    end
  end

  subject { create(:answer) }
  it_behaves_like "a ratingable"
end
