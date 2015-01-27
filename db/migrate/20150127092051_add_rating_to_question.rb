class AddRatingToQuestion < ActiveRecord::Migration
  def change
    add_column :questions, :rating, :decimal
  end
end
