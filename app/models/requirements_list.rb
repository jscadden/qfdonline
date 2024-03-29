class RequirementsList < ActiveRecord::Base
  include Enumerable

  # essentially a many to many table
  has_many :requirements, :order => "position"

  with_options(:class_name => "Hoq") do |o|
    o.has_one :primary_hoq, :foreign_key => "primary_requirements_list_id"
    o.has_one :secondary_hoq, :foreign_key => "secondary_requirements_list_id"
  end

  has_one :correlated_requirements_list, :through => :secondary_hoq, 
            :source => "primary_requirements_list"

  accepts_nested_attributes_for :requirements, :allow_destroy => true


  def requirement_weight_changed
    recalc_relative_weights
    if primary_hoq
      # the secondary requirements list of the last hoq in the qfd will not
      # have a primary hoq
      primary_hoq.recalc_secondary_weights
    end
  end

  def recalc_weights
    # I am my HOQ's secondary requirements list, I was told to update my
    # weights, because my HOQ's primary requirements list has had a weight
    # updated.
    requirements.each {|req| req.recalc_weight}
  end

  def sort(attr, asc=true)
    check_sort_attr(attr)
    Requirement.transaction do
      in_order = requirements.all(:order => "#{attr} #{asc ? "ASC" : "DESC"}")
      in_order.each_with_index do |req, idx|
        req.update_attribute(:position, idx + 1)
      end
    end
  end

  delegate :each, :to => :requirements


  private

  def check_sort_attr(attr)
    unless Requirement.column_names.include?(attr.to_s)
      raise ArgumentError.new("invalid sort attribute #{attr.inspect}")
    end
  end

  def recalc_relative_weights
    total = requirements.sum(:weight).to_f

    if total.to_f > 0
      requirements.each do |req|
        req.recalc_relative_weight(total)
      end
    end
  end

end
