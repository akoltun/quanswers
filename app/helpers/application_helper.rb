module ApplicationHelper
  def collection_cache_key_for(model, author_seeable)
    klass = model.to_s.classify.constantize
    count = klass.count
    max_updated_at = klass.maximum(:updated_at).try(:utc).try(:to_s, :number)
    "#{author_seeable}/#{model.to_s.pluralize}/collection-#{count}-#{max_updated_at}"
  end
end
