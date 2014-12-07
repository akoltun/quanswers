require 'rails_helper'

RSpec.describe Question, :type => :model do
  it { is_expected.to respond_to(:question) }

  it { is_expected.to validate_presence_of(:question)}

  it { is_expected.to ensure_length_of(:question).is_at_most(2000) }
end
