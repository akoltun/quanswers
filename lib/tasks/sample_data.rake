namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_user('admin', 'admin@test.com', true)
    make_user('test3', 'test3@test.com')
    make_questions(user2 = make_user('test2', 'test2@test.com'), 20)
    make_questions(user1 = make_user('test1', 'test1@test.com'), 30)
    make_questions(user0 = make_user('test', 'test@test.com'), 50)
    make_ratings_for [user0, user1, user2]
    make_tags 10
    tag_questions 4
  end
end

def make_user(user_name, email, admin = false)
  User.create!(username: user_name, email: email, password: '12345678', admin: admin)
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

def make_ratings_for(users)
  Question.find_each do |question|
    users.each do |user|
      if question.user != user
        question.rating!(user, rand(50)/10.0)
      end
    end
  end
  Answer.find_each do |answer|
    users.each do |user|
      if answer.user != user
        answer.rating!(user, rand(50)/10.0)
      end
    end
  end
end

def make_tags(count)
  count.times { Tag.create!(name: Faker::Lorem.words(1 + rand(3)).join(' '), color_index: rand(6)) }
end

def tag_questions(count)
  tags = Tag.all
  Question.find_each do |question|
    rand(count).times do
      tag = tags[rand(tags.count)]
      question.tags << tag unless question.tags.exists? tag
    end
  end
end