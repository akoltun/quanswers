FactoryGirl.define do
  factory :answer do
    user
    question
    answer    "MyText"

    factory :invalid_answer do
      answer nil
    end

    factory :another_answer do
      answer   "Another Answer"
    end

    factory :unique_answer do
      sequence(:answer) { |n| "My Answer #{n}" }
    end
  end

end
