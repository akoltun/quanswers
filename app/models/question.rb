class Question < ActiveRecord::Base
  include Ratingable

  belongs_to :user
  has_many :answers, dependent: :destroy
  belongs_to :best_answer, class_name: 'Answer'
  has_many :remarks, as: :remarkable, dependent: :destroy
  has_many :attachments, as: :attachmentable, dependent: :destroy
  has_many :ratings, as: :ratingable, dependent: :destroy

  validates :user, :title, presence: true
  validates :title, length: { maximum: 250 }
  validates :question, length: { maximum: 2000 }

  scope :ordered_by_creation_date, -> { order(created_at: :desc) }
  scope :last_day, -> { where(created_at: Date.yesterday...Date.today) }

  accepts_nested_attributes_for :attachments, allow_destroy: true, reject_if: proc { |attr| attr['file'].nil? }
end
