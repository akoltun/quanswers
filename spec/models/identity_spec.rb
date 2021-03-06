require 'rails_helper'

RSpec.describe Identity, :type => :model do
  it { is_expected.to belong_to :user }
  it { is_expected.to validate_presence_of :user }
  it { is_expected.to have_db_index([:provider, :uid]).unique }
end
