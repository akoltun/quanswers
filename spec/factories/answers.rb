FactoryGirl.define do
  factory :answer do
    association :question
    answer      "MyText"

    factory :invalid_answer do
      answer nil
    end
  end

end
