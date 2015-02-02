module QuestionsHelper
  def tag_color(color_index)
    color_array = %w[label-default label-primary label-success label-info label-warning label-danger]
    color_array[color_index % color_array.count]
  end
end
