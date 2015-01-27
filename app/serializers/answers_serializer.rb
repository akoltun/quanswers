class AnswersSerializer < ActiveModel::Serializer
  attributes :id, :answer, :created_at, :updated_at
end
