class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user
  has_many :remarks, as: :remarkable, dependent: :destroy

  validates :question, :user, presence: true
  validates :answer, presence: true, length: { maximum: 2000 }

  scope :ordered_by_creation_date, -> { order(created_at: :desc) }
end
