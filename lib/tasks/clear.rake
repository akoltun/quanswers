namespace :db do
  desc "Clear database"
  task clear: :environment do
    clear_answers
    clear_questions
    clear_users
  end
end

def clear_answers
  Answer.all.each do |answer|
    answer.destroy
  end
end

def clear_questions
  Question.all.each do |question|
    question.destroy
  end
end

def clear_users
  User.all.each do |user|
    user.destroy
  end
end

