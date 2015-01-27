class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :answer, :created_at, :updated_at

  has_many :remarks
  has_many :attachments
end
