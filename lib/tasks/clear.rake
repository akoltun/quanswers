namespace :db do
  desc "Clear database"
  task clear: :environment do
    clear_klass Answer
    clear_klass Question
    clear_klass User
    clear_klass Tag
    clear_klass UserConfirmationRequest
  end
end

def clear_klass(klass)
  klass.find_each do |item|
    item.destroy
  end
end

