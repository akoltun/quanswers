class Answer < ActiveRecord::Base
  include Ratingable

  belongs_to :question, touch: true
  belongs_to :user
  has_many :remarks, as: :remarkable, dependent: :destroy
  has_many :attachments, as: :attachmentable, dependent: :destroy
  has_many :ratings, as: :ratingable, dependent: :destroy

  validates :question, :user, presence: true
  validates :answer, presence: true, length: { maximum: 2000 }

  after_destroy :no_more_best!
  after_create :send_notification_email

  scope :ordered_by_creation_date, -> { order(created_at: :desc) }

  accepts_nested_attributes_for :attachments, allow_destroy: true, reject_if: proc { |attr| attr['file'].nil? }

  def best!
    question.best_answer = self
  end

  def best?
    question.best_answer == self
  end

  private

  def no_more_best!
    if question.best_answer == self
      question.best_answer = nil
      question.save
    end
  end

  def send_notification_email
    NewAnswerNotificationWorker.perform_async(id)
  rescue
    # Как лучше залоггировать ошибку?
    return
  end
end
