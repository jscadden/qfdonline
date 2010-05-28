class HoqListObserver < ActiveRecord::Observer
  def after_create(hoq_list)
    hoq = hoq_list.hoqs.new(:name => "Example HOQ")
    hoq_list.insert_front(hoq)
  end
end
