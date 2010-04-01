class RequirementsList < ActiveRecord::Base
  # essentially a many to many table
  has_many :requirements

  has_one :primary_hoq, :class_name => "Hoq", :foreign_key => "primary_requirements_list_id"
  has_one :secondary_hoq, :class_name => "Hoq", :foreign_key => "secondary_requirements_list_id"
end
