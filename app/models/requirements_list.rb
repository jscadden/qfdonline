class RequirementsList < ActiveRecord::Base
  # essentially a many to many table
  has_many :requirements, :order => "position"

  has_one :primary_hoq, :class_name => "Hoq", :foreign_key => "primary_requirements_list_id"
  has_one :secondary_hoq, :class_name => "Hoq", :foreign_key => "secondary_requirements_list_id"


  def requirement_weight_changed
    recalc_relative_weights
  end


  private

  def recalc_relative_weights
    logger.debug("no op")
  end

end
