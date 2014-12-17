class Question < ActiveRecord::Base
  validates_presence_of :title
  validates_length_of :title, maximum: 250
  validates_length_of :question, maximum: 2000

  has_many :answers

  scope :ordered_by_creation_date, -> { order(created_at: :desc) }
end
