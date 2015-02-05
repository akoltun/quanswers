ThinkingSphinx::Index.define :remark, with: :active_record do
  #fileds
  indexes remark
  indexes user.username, as: :author, sortable: true

  # attributes
  has user_id, created_at, updated_at
end