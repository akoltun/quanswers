class Answer < ActiveRecord::Base
  validates :question, presence: true
  validates :answer, presence: true, length: { maximum: 2000 }

  belongs_to :question

  scope :ordered_by_creation_date, -> { order(created_at: :desc) }
end
