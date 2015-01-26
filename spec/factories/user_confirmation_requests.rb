FactoryGirl.define do
  factory :user_confirmation_request do
    provider "MyString"
    uid "MyString"
    email "test@test.test"
    username "MyString"
    request_session_created_at Time.current
  end

end
