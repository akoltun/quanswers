module Ratingable
  def rating!(user, value)
    return if value.nil?

    current_rating = ratings.where(user: user).first
    if current_rating
      current_rating.update!(rating: value)
    else
      ratings.create!(user: user, rating: value)
    end
    update!(rating: ratings.average(:rating).round(1))
  end
end