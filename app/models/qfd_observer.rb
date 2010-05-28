class QfdObserver < ActiveRecord::Observer
  def after_create(qfd)
    qfd.build_hoq_list.save!
  end
end
