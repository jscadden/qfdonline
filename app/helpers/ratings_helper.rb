module RatingsHelper

  def number_to_relative_weight(relative_weight)
    number_to_percentage(relative_weight, :precision => 2)
  end

  def number_to_weight(weight)
    number_with_precision(weight, :precision => 2)
  end

end
