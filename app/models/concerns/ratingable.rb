module Ratingable
  def rating
    value = ratings.average(:rating)
    value.round(1) if value
  end

  def rating!(user, value)
    return if value.nil?
    current_rating = ratings.where(user: user).first
    if current_rating
      current_rating.update!(rating: value)
    else
      ratings.create!(user: user, rating: value).nil?
    end
  end
end