class AddBestAnswerToQuestion < ActiveRecord::Migration
  def change
    add_column :questions, :best_answer_id, :integer

    add_index :questions, :best_answer_id
  end
end
