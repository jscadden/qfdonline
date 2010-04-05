class Requirement < ActiveRecord::Base
  belongs_to :requirements_list
  acts_as_list :scope => :requirements_list

  validates_presence_of :name
  validates_uniqueness_of :name, :scope => :requirements_list_id
  validates_numericality_of :weight, :relative_weight, :allow_nil => true

  with_options(:class_name => "Rating") do |r|
    r.has_one :primary_rating, :foreign_key => "primary_requirement_id"
    r.has_one :secondary_rating, :foreign_key => "secondary_requirement_id"
  end

  def recalc_relative_weight(total)
    self.update_attributes(:relative_weight => weight / total * 100)
  end

end
