class AddRequestSessionCreatedAtToUserConfirmationRequest < ActiveRecord::Migration
  def change
    add_column :user_confirmation_requests, :request_session_created_at, :datetime
  end
end
