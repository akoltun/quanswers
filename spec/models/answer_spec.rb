require 'rails_helper'

RSpec.describe Answer, :type => :model do
  it { is_expected.to validate_presence_of(:user) }
  it { is_expected.to validate_presence_of(:question) }
  it { is_expected.to validate_presence_of(:answer) }

  it { is_expected.to ensure_length_of(:answer).is_at_most(2000) }

  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:question) }

  it { is_expected.to have_db_index(:user_id).unique(false) }
  it { is_expected.to have_db_index(:question_id).unique(false) }
end
