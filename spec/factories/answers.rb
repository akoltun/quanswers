FactoryGirl.define do
  factory :answer do
    association :question
    answer      "MyText"
  end

end
