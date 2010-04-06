class RequirementsList < ActiveRecord::Base
  # essentially a many to many table
  has_many :requirements, :order => "position"

  has_one :primary_hoq, :class_name => "Hoq", :foreign_key => "primary_requirements_list_id"
  has_one :secondary_hoq, :class_name => "Hoq", :foreign_key => "secondary_requirements_list_id"


  def requirement_weight_changed
    recalc_relative_weights
  end

  def owns_rating?(rating)
    requirements.any? {|r| r.owns_rating?(rating)}
  end


  private

  def recalc_relative_weights
    total = requirements.sum(:weight).to_f

    requirements.each do |req|
      req.recalc_relative_weight(total)
    end
  end

end
