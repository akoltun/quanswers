class RemarkSerializer < ActiveModel::Serializer
  attributes :id, :remark, :created_at, :updated_at
end
