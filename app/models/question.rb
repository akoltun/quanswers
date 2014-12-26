class Question < ActiveRecord::Base
  validates :user, :title, presence: true
  validates :title, length: { maximum: 250 }
  validates :question, length: { maximum: 2000 }

  belongs_to :user
  has_many :answers

  scope :ordered_by_creation_date, -> { order(created_at: :desc) }
end
