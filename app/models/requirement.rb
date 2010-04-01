class Requirement < ActiveRecord::Base
  belongs_to :requirements_list
  acts_as_list :scope => :requirements_list

  validates_presence_of :name
  validates_uniqueness_of :name, :scope => :requirements_list_id
end
