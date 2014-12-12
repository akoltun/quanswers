namespace :db do
  desc "Clear database"
  task clear: :environment do
    clear_questions
  end
end

def clear_questions
  Question.all.each do |question|
    question.destroy
  end
end

