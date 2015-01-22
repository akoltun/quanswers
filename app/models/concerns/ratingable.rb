module Ratingable
  def rating
    ratings.average(:rating)
  end
end