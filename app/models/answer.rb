class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user
  has_many :remarks, as: :remarkable, dependent: :destroy
  has_many :attachments, as: :attachmentable, dependent: :destroy

  validates :question, :user, presence: true
  validates :answer, presence: true, length: { maximum: 2000 }

  scope :ordered_by_creation_date, -> { order(created_at: :desc) }

  accepts_nested_attributes_for :attachments, allow_destroy: true, reject_if: proc { |attr| attr['file'].nil? }

  def best!
    question.best_answer = self
  end

  def best?
    question.best_answer == self
  end
end
