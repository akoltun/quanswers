class Answer < ActiveRecord::Base
  validates :question, presence: true
  validates :answer, presence: true, length: { maximum: 2000 }

  belongs_to :question
end
