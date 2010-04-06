class Qfd < ActiveRecord::Base
  belongs_to :user

  has_one :hoq_list
  has_many :hoqs, :through => :hoq_list

  validates_presence_of :name

  after_create :create_hoq_list

  def owns_rating?(rating)
    hoqs.any? {|h| h.owns_rating?(rating)}
  end
end
