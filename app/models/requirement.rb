class Requirement < ActiveRecord::Base
  belongs_to :requirements_list
  acts_as_list :scope => :requirements_list

  has_one :primary_hoq, :through => :requirements_list

  validates_presence_of :name
  validates_uniqueness_of :name, :scope => :requirements_list_id
  validates_numericality_of :weight, :relative_weight, :allow_nil => true,
    :greater_than_or_equal_to => 0.0

  with_options(:class_name => "Rating") do |r|
    r.has_many :primary_ratings, :foreign_key => "primary_requirement_id"
    r.has_many :secondary_ratings, :foreign_key => "secondary_requirement_id"
  end

  def recalc_relative_weight(total)
    self.update_attributes(:relative_weight => weight / total * 100)
  end

  def owns_rating?(rating)
    primary_ratings.include?(rating) || secondary_ratings.include?(rating)
  end

  def weight=(value)
    value = value.to_s.gsub(/[,]/, "")
    write_attribute(:weight, value)
  end
end
