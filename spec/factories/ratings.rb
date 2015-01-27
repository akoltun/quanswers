FactoryGirl.define do
  factory :rating do
    ratingable nil
    user
    rating 3

    after(:create) do |rating|
      rating.ratingable.update!(rating: rating.ratingable.ratings.average(:rating).round(1))
    end
  end

end
