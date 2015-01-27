class AddRatingToAnswer < ActiveRecord::Migration
  def change
    add_column :answers, :rating, :decimal
  end
end
