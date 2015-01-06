class Question < ActiveRecord::Base
  belongs_to :user
  has_many :answers
  has_many :remarks, as: :remarkable, dependent: :destroy

  validates :user, :title, presence: true
  validates :title, length: { maximum: 250 }
  validates :question, length: { maximum: 2000 }

  scope :ordered_by_creation_date, -> { order(created_at: :desc) }
end
