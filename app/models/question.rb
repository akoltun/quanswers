class Question < ActiveRecord::Base
  belongs_to :user
  has_many :answers, dependent: :destroy
  has_many :remarks, as: :remarkable, dependent: :destroy
  has_many :attachments, dependent: :destroy

  validates :user, :title, presence: true
  validates :title, length: { maximum: 250 }
  validates :question, length: { maximum: 2000 }

  scope :ordered_by_creation_date, -> { order(created_at: :desc) }

  accepts_nested_attributes_for :attachments, allow_destroy: true, reject_if: proc { |attr| attr['file'].nil? }
end
