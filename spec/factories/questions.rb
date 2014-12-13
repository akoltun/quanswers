FactoryGirl.define do
  factory :question do
    title    "MyText"
    question "MyText"

    factory :invalid_question do
      title nil
    end

    factory :another_question do
      title    "Another title"
      question "Another Question"
    end
  end
end
