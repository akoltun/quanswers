class CreateUserConfirmation < ActiveRecord::Migration
  def change
    create_table :user_confirmation_requests do |t|
      t.string :provider
      t.string :uid
      t.string :email
      t.string :username
      t.string :confirmation_token

      t.timestamps
    end

    add_index :user_confirmation_requests, [:provider, :uid], unique: true
  end
end
