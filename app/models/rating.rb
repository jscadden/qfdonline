class Rating < ActiveRecord::Base

  with_options(:class_name => "Requirement") do |r|
    r.belongs_to :primary_requirement
    r.belongs_to :secondary_requirement
  end

  validates_uniqueness_of :primary_requirement_id, :scope => :secondary_requirement_id
  validates_uniqueness_of :secondary_requirement_id, :scope => :primary_requirement_id

  def self.lookup(pri_req, sec_req)
    find_by_primary_requirement_id_and_secondary_requirement_id(pri_req.id,
                                                                sec_req.id)
  end

  def self.maximum_as_primary(req)
    maximum(:value, :conditions => ["primary_requirement_id = ?", req.id])
  end

  def self.maximum_as_secondary(req)
    maximum(:value, :conditions => ["secondary_requirement_id = ?", req.id])
  end


  private

  VALID_VALUES = [1, 3, 9,]

  validates_inclusion_of :value, :in => VALID_VALUES, :allow_nil => true
end
