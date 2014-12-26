FactoryGirl.define do
  factory :question do
    user
    title    "MyText"
    question "MyText"

    factory :invalid_question do
      title nil
    end

    factory :another_question do
      title    "Another title"
      question "Another Question"
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
