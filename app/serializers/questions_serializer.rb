class QuestionsSerializer < ActiveModel::Serializer
  attributes :id, :title, :question, :created_at, :updated_at

  has_many :answers, serializer: AnswersSerializer
end
