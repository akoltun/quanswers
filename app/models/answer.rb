class Answer < ActiveRecord::Base
  validates :question, :user, presence: true
  validates :answer, presence: true, length: { maximum: 2000 }

  belongs_to :question
  belongs_to :user

  scope :ordered_by_creation_date, -> { order(created_at: :desc) }
end
