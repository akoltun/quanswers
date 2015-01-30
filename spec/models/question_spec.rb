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
end
