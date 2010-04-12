class RatingObserver < ActiveRecord::Observer

  def after_save(rating)
    if rating.value_changed?
      rating.secondary_requirement.secondary_rating_changed
    end
  end

  def after_destroy(rating)
    rating.secondary_requirement.secondary_rating_changed
  end
end
