module HoqListExtensions

  def at(pos)
    find_by_position(pos) or 
      raise IndexError.new("No HOQ found at pos #{pos.inspect} #{find(:all).map(&:position).inspect}")
  end

  def at_or_after(pos)
    find(:all, :conditions => ["position >= ?", pos], :order => "position ASC")
  end

end
