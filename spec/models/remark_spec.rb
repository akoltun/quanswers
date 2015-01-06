require 'rails_helper'

RSpec.describe Remark, :type => :model do
  it { is_expected.to validate_presence_of(:user) }
  it { is_expected.to validate_presence_of(:remarkable) }
  it { is_expected.to validate_presence_of(:remark) }

  it { is_expected.to ensure_length_of(:remark).is_at_most(2000) }

  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:remarkable) }

  it { is_expected.to have_db_index(:user_id).unique(false) }
  it { is_expected.to have_db_index([:remarkable_type, :remarkable_id]).unique(false) }
end
