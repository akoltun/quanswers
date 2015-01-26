json.(@remark, :id, :remark, :remarkable_type, :remarkable_id, :user_id)
json.created_at @remark.created_at.to_s(:long)
json.updated_at @remark.updated_at.to_s(:long)
if can? :see, :author
  json.author @remark.user.username
end