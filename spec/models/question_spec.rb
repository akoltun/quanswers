require 'rails_helper'

RSpec.describe Question, "model", :type => :model do
  it { is_expected.to validate_presence_of(:user)}
  it { is_expected.to validate_presence_of(:title)}
  it { is_expected.not_to validate_presence_of(:question)}

  it { is_expected.to ensure_length_of(:title).is_at_most(250) }
  it { is_expected.to ensure_length_of(:question).is_at_most(2000) }

  it { is_expected.to have_many(:answers) }
  it { is_expected.to have_many(:remarks) }
  it { is_expected.to belong_to(:user) }

  it { is_expected.to have_db_index(:user_id) }
end
