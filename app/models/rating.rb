class Rating < ActiveRecord::Base

  with_options(:class_name => "Requirement") do |r|
    r.belongs_to :primary_requirement
    r.belongs_to :secondary_requirement
  end

  def self.lookup(pri_req, sec_req)
    find_by_primary_requirement_id_and_secondary_requirement_id(pri_req,
                                                                sec_req)
  end


  private

  VALID_VALUES = [1, 3, 9,]

  validates_inclusion_of :value, :in => VALID_VALUES, :allow_nil => true
end
