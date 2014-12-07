class Question < ActiveRecord::Base
  validates_presence_of :question
  validates_length_of :question, maximum: 2000
end
