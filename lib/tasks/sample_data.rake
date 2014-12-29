namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_users
  end
end

def make_users
  make_questions(User.create!(email: 'test@test.com', password: '12345678'), 20)
  make_questions(User.create!(email: 'test1@test.com', password: '12345678'), 30)
  make_questions(User.create!(email: 'test2@test.com', password: '12345678'), 50)
  User.create!(email: 'test3@test.com', password: '12345678')
end

def make_questions(user, count)
  count.times do |n|
    question = Question.create!(user: user, title: Faker::Lorem.sentence, question: Faker::Lorem.paragraph(10))

    rand(6).times do |i|
      question.answers.create!(answer: Faker::Lorem.paragraph(10), user: FactoryGirl.create(:user, email_base: "sample.com"))
    end

    rand(4).times do |i|
      question.answers.create!(answer: Faker::Lorem.paragraph(10), user: user)
    end
  end
end

