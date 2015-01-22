FactoryGirl.define do
  factory :answer do
    user
    question
    answer    "My Answer"

    factory :invalid_answer do
      answer nil
    end

    factory :another_answer do
      answer   "Another Answer"
    end

    factory :unique_answer do
      sequence(:answer) { |n| "My #{n} Answer" }

      factory :unique_answer_with_rating do
        after(:create) do |answer|
          create(:rating, ratingable: answer)
        end
      end
    end
  end

end
