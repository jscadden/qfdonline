class Hoq < ActiveRecord::Base
  belongs_to :qfd

  validates_presence_of :name
end
