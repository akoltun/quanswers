FactoryGirl.define do
  factory :remark do
    user
    remark    "MyRemark"

    factory :unique_remark do
      sequence(:remark)  { |n| "Remark-#{n}" }
    end

    factory :invalid_remark do
      remark  nil
    end
  end
end
