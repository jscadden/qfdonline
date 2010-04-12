class Hoq < ActiveRecord::Base
  include HoqExtensions::RequirementsLists

  belongs_to :hoq_list
  acts_as_list :scope => :hoq_list
  has_one :qfd, :through => :hoq_list

  belongs_to :primary_requirements_list, 
               :class_name => "RequirementsList", :touch => true
  belongs_to :secondary_requirements_list, 
               :class_name => "RequirementsList", :touch => true

  has_many :primary_requirements, :through => :primary_requirements_list, 
             :source => :requirements
  has_many :secondary_requirements, :through => :secondary_requirements_list, 
             :source => :requirements

  validates_presence_of :name

  with_options(:scope => :hoq_list) do
    validates_uniqueness_of :primary_requirements_list_id
    validates_uniqueness_of :secondary_requirements_list_id
  end

  def owns_rating?(rating)
    primary_requirements_list.owns_rating?(rating) ||
      secondary_requirements_list.owns_rating?(rating)
  end

  def recalc_secondary_weights
    secondary_requirements_list.recalc_weights
  end
end
