module Taggable
  def tags_list
    tags.pluck(:name).join(', ')
  end

  def tags_list=(values)
    names = values.split(',').map { |s| s.strip if s }.keep_if { |s| s && s != '' }

    tags.find_each do |tag|
      if names.include? tag.name
        names.delete(tag.name)
      else
        tags.destroy(tag)
      end
    end

    names.each { |name| tags.build(name: name) }

    # TODO: Make touch conditionally in order to change updated_at to invalidate question cache
  end
end