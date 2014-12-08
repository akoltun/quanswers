class Answer < ActiveRecord::Base
  validates_presence_of :question, :answer
  validates_length_of :answer, maximum: 2000

  belongs_to :question
end
