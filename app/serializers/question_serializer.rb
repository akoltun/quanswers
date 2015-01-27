class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :question, :created_at, :updated_at

  has_many :remarks
  has_many :attachments
end
