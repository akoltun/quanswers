require 'rails_helper'

RSpec.describe Question, "model", :type => :model do
  it { is_expected.to validate_presence_of(:user)}
  it { is_expected.to validate_presence_of(:title)}
  it { is_expected.not_to validate_presence_of(:question)}

  it { is_expected.to ensure_length_of(:title).is_at_most(250) }
  it { is_expected.to ensure_length_of(:question).is_at_most(2000) }

  it { is_expected.to have_many(:ratings).dependent(:destroy) }
  it { is_expected.to have_many(:answers).dependent(:destroy) }
  it { is_expected.to belong_to(:best_answer).class_name('Answer') }
  it { is_expected.to have_many(:remarks) }
  it { is_expected.to have_many(:attachments).dependent(:destroy) }
  it { is_expected.to belong_to(:user) }
  it { is_expected.to accept_nested_attributes_for :attachments }

  it { is_expected.to have_db_index(:user_id) }

  subject { create(:question) }
  it_behaves_like "a ratingable"

  describe "last_day scope" do
    let(:old_question) { create(:question) }
    let(:good_question_1) { create(:question) }
    let(:good_question_2) { create(:question) }
    let(:good_questions) { [good_question_1, good_question_2] }
    let(:new_question) { create(:question) }

    before do
      Timecop.freeze Time.new(2015, 1, 1, 23, 59, 59, 0)
      old_question

      Timecop.freeze Time.new(2015, 1, 2,  0,  0,  0, 0)
      good_question_1

      Timecop.freeze Time.new(2015, 1, 2, 23, 59, 59, 0)
      good_question_2

      Timecop.freeze Time.new(2015, 1, 3,  0,  0,  0, 0)
      new_question

      Timecop.travel Time.new(2015, 1, 3, 10,  0,  0, 0)
    end

    it "returns yesterday questions" do
      expect(Question.last_day).to include *good_questions
    end

    it "doesn't return questions older then yesterday" do
      expect(Question.last_day).not_to include old_question
    end

    it "doesn't return questions newer then yesterday" do
      expect(Question.last_day).not_to include new_question
    end
  end
end
