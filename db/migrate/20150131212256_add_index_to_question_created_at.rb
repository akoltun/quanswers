class AddIndexToQuestionCreatedAt < ActiveRecord::Migration
  def change
    add_index :questions, :created_at
  end
end
