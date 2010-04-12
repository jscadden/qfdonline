class Requirement < ActiveRecord::Base
  belongs_to :requirements_list
  acts_as_list :scope => :requirements_list

  has_one :primary_hoq, :through => :requirements_list
  has_one :secondary_hoq, :through => :requirements_list

  delegate :correlated_requirements_list, :to => :requirements_list

  validates_presence_of :name
  validates_numericality_of :weight, :relative_weight, :allow_nil => true,
    :greater_than_or_equal_to => 0.0

  with_options(:class_name => "Rating") do |r|
    r.has_many :primary_ratings, :foreign_key => "primary_requirement_id"
    r.has_many :secondary_ratings, :foreign_key => "secondary_requirement_id"
  end

  attr_accessor :requested_position

  def recalc_relative_weight(total)
    self.update_attributes(:relative_weight => weight.to_f / total * 100)
  end

  def recalc_weight
    list = correlated_requirements_list || []
    weight = list.inject(0) do |total, cor_req|
      rating = Rating.lookup(cor_req, self)
      total += rating ? rating.value * cor_req.relative_weight.to_f : 0
    end
    self.update_attributes(:weight => weight)
  end

  # Puts us in the same requirements list as our new sibling, useful in ajax
  # when inserting new columns or rows into a matrix.
  def sibling_id=(id)
    self.requirements_list = Requirement.find(id).requirements_list
  end

  def secondary_rating_changed
    recalc_weight
  end

  def owns_rating?(rating)
    primary_ratings.include?(rating) || secondary_ratings.include?(rating)
  end

  def weight=(value)
    value = value.to_s.gsub(/[,]/, "")
    write_attribute(:weight, value)
  end

  
end
