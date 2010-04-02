class HoqList < ActiveRecord::Base
  include Enumerable

  belongs_to :qfd
  has_many :hoqs, :order => "position", :extend => HoqListExtensions

  def insert_at(hoq, pos)
    handle_insert_at(hoq, pos)
  end

  def insert_front(hoq)
    insert_at(hoq, 1)
  end

  def insert_back(hoq)
    insert_at(hoq, hoqs.size+1)
  end

  delegate :each, :to => :hoqs


  private

  def check_pos(pos)
    unless pos.is_a?(Integer)
      raise TypeError.new("Pos must be an integer")
    end

    if pos < 1 || pos > hoqs.size+1
      raise IndexError.new("Pos must be [1,hoq_list.size+1]")
    end
  end

  def check_new_record
    if self.new_record?
      logger.warn("HoqList #{self} is not yet saved, " +
                  "I hope you know what you're doing!")
    end
  end

  def handle_insert_at(hoq, pos)
    check_pos(pos)
    check_new_record

    if hoqs.empty?
      handle_empty_insert(hoq)
    elsif 1 == pos
      handle_front_insert(hoq)
    elsif hoqs.size < pos
      handle_back_insert(hoq)
    else
      handle_insert_mid(hoq, pos)
    end

    hoqs << hoq
  end

  def handle_front_insert(hoq)
    hoq.acquire_secondary_requirements_list_from(hoqs.at(1))
    hoq.build_new_primary_requirements_list

    hoqs.all.each do |h|
      h.increment!(:position)
    end
    hoq.position = 1
  end

  def handle_back_insert(hoq)
    hoq.inherit_primary_requirements_list_from(hoqs.at(hoqs.size))
    hoq.build_new_secondary_requirements_list

    hoq.position = hoqs.size + 1
  end

  def handle_empty_insert(hoq)
    hoq.build_new_primary_requirements_list
    hoq.build_new_secondary_requirements_list

    hoq.position = 1
  end

  def handle_insert_mid(hoq, pos)
    hoq.bequeath_secondary_requirements_list_to(hoqs.at(pos))
    hoq.inherit_primary_requirements_list_from(hoqs.at(pos - 1))

    hoqs.at_or_after(pos).each do |h|
      h.increment!(:position)
    end
    hoq.position = pos
  end


  
end
