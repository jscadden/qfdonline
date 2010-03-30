class Qfd < ActiveRecord::Base
  belongs_to :user
  has_many :hoqs

  validates_presence_of :name
end
