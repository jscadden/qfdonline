class Hoq < ActiveRecord::Base
  belongs_to :qfd
  has_many :requirements

  validates_presence_of :name
end
