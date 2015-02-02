class CreateQuestionsTags < ActiveRecord::Migration
  def change
    create_table :questions_tags do |t|
      t.references :question
      t.references :tag, index: true
    end

    if Rails.env.test? || Rails.env.development?
      add_index :questions_tags, [:question_id, :tag_id], unique: true
    else
      add_index :questions_tags, :question_id
    end
  end
end
