class Requirement < ActiveRecord::Base
  belongs_to :hoq

  validates_presence_of :name
end
