class Remark < ActiveRecord::Base
  belongs_to :user
  belongs_to :question

  validates :user, :question, :remark, presence:  true
  validates :remark, length: { maximum: 2000 }

  scope :ordered_by_creation_date, -> { order(created_at: :asc) }
end
