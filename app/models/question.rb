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

  accepts_nested_attributes_for :attachments, allow_destroy: true, reject_if: proc { |attr| attr['file'].nil? }

  def rating!(rating_value)
    return false if current_user == user

    current_rating = ratings.where(user: current_user).first
    if current_rating
      current_rating.update(rating: rating_value)
    else
      ratings.create(user: current_user, rating: rating_value)
    end
  end
end
