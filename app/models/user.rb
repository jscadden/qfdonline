class User < ActiveRecord::Base
  acts_as_authentic

  has_many :qfds

  def owns_rating?(rating)
    qfds.any? {|q| q.owns_rating?(rating)}
  end
end
