class AttachmentSerializer < ActiveModel::Serializer
  attributes :id, :filename, :url, :created_at, :updated_at

  def filename
    object.file.identifier
  end

  def url
    object.file.url
  end
end
