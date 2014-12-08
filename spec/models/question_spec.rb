require 'rails_helper'

RSpec.describe Question, :type => :model do
  it { is_expected.to validate_presence_of(:title)}
  it { is_expected.not_to validate_presence_of(:question)}

  it { is_expected.to ensure_length_of(:title).is_at_most(250) }
  it { is_expected.to ensure_length_of(:question).is_at_most(2000) }
end
