class CreateQuestionsUsers < ActiveRecord::Migration
  def change
    create_table :questions_users do |t|
      t.references :question, index: true
      t.references :user, index: true
    end
  end
end
