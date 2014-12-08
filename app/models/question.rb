class Question < ActiveRecord::Base
  validates_presence_of :title
  validates_length_of :title, maximum: 250
  validates_length_of :question, maximum: 2000
end
