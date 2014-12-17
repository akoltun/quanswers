namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_questions
  end
end

def make_questions
  99.times do |n|
    question = Question.create!(title: Faker::Lorem.sentence, question: Faker::Lorem.paragraph(10))

    rand(10).times do |i|
      question.answers.create!(answer: Faker::Lorem.paragraph(10))
    end
  end
end 

