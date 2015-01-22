require 'rails_helper'

RSpec.describe Rating, :type => :model do
  it { is_expected.to validate_presence_of :user  }
  it { is_expected.to validate_presence_of :ratingable  }
  it { is_expected.to validate_presence_of :rating  }
  it { is_expected.to validate_numericality_of(:rating).is_greater_than_or_equal_to(0).is_less_than_or_equal_to(5) }
  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:ratingable) }
end
