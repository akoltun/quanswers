namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_user('test3@test.com')
    make_questions make_user('test2@test.com'), 20
    make_questions make_user('test1@test.com'), 30
    make_questions make_user('test@test.com'), 50
  end
end

def make_user(email)
  User.create!(email: email, password: '12345678')
end

def make_questions(user, count)
  count.times do |n|
    question = Question.create!(user: user, title: Faker::Lorem.sentence, question: Faker::Lorem.paragraph(10))

    make_answers(question, 6, user)

    make_remarks(question, 3, user)

    set_best_answer(question)
  end
end

def make_answers(question, count, user = nil)
  rand(count).times do |i|
    answer = question.answers.create!(answer: Faker::Lorem.paragraph(10), user: user || FactoryGirl.create(:user, email_base: "sample.com"))

    make_remarks(answer, 3, user)
  end
end

def make_remarks(remarkable, count, user = nil)
  rand(count).times do |i|
    remarkable.remarks.create!(remark: Faker::Lorem.paragraph(4), user: user || FactoryGirl.create(:user, email_base: "sample.com"))
  end
end

def set_best_answer(question)
  question.update!(best_answer: question.answers[rand(question.answers.size)])
end