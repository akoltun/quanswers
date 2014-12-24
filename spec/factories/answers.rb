FactoryGirl.define do
  factory :answer do
    association :question
    answer      "MyText"

    factory :invalid_answer do
      answer nil
    end

    factory :another_answer do
      answer   "Another Answer"
    end
  end

end
