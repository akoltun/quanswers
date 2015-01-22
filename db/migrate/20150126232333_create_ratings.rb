class CreateRatings < ActiveRecord::Migration
  def change
    create_table :ratings do |t|
      t.string :ratingable_type
      t.references :ratingable
      t.references :user, index: true
      t.decimal :rating

      t.timestamps
    end

    add_index :ratings, [:ratingable_type, :ratingable_id, :user_id], unique: true
  end
end
