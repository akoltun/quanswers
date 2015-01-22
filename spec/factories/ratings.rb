FactoryGirl.define do
  factory :rating do
    ratingable nil
    user
    rating 3
  end

end
