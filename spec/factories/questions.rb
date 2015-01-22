FactoryGirl.define do
  factory :question do
    user
    title     "My Question Title"
    question  "My Question Body"

    factory :invalid_question do
      title nil
    end

    factory :another_question do
      title    "Another title"
      question "Another Question"
    end

    factory :unique_question do
      sequence(:title)    { |n| "My Question #{n} Title" }
      sequence(:question) { |n| "My Question #{n} Body" }

      factory :unique_question_with_rating do
        after(:create) do |question|
          create(:rating, ratingable: question)
        end
      end
    end

    factory :question_with_answers do
      transient do
        answers_count 2
      end

      after(:create) do |question, evaluator|
        create_list(:answer, evaluator.answers_count, question: question)
      end
    end
  end
end
