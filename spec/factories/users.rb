FactoryGirl.define do
  factory :user do
    transient { email_base "example.com" }

    sequence(:email)      { |n| "user#{n}@#{email_base}" }
    password              '12345678'
    password_confirmation '12345678'
  end

end
