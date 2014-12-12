namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_questions
  end
end

def make_questions
  99.times do |n|
    Question.create!(title: Faker::Lorem.sentence, question: Faker::Lorem.paragraph(10))
  end
end 

