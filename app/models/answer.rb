class Answer < ActiveRecord::Base
  include Ratingable

  belongs_to :question
  belongs_to :user
  has_many :remarks, as: :remarkable, dependent: :destroy
  has_many :attachments, as: :attachmentable, dependent: :destroy
  has_many :ratings, as: :ratingable, dependent: :destroy

  validates :question, :user, presence: true
  validates :answer, presence: true, length: { maximum: 2000 }

  after_destroy :no_more_best!

  scope :ordered_by_creation_date, -> { order(created_at: :desc) }

  accepts_nested_attributes_for :attachments, allow_destroy: true, reject_if: proc { |attr| attr['file'].nil? }

  def best!
    question.best_answer = self
  end

  def best?
    question.best_answer == self
  end

  def set_rating(rating_value)
    return false if current_user = user

    current_rating = ratings.where(user: current_user).first
    if current_rating
      current_rating.update(rating: rating_value)
    else
      ratings.create(user: current_user, rating: rating_value)
    end
  end

  private

  def no_more_best!
    if question.best_answer == self
      question.best_answer = nil
      question.save
    end
  end
end
