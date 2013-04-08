class RequirementObserver < ActiveRecord::Observer

  def after_save(requirement)
    if requirement.requested_position
      pos = requirement.requested_position
      requirement.requested_position = nil
      requirement.insert_at(pos.to_i)
    end
    if requirement.weight_changed?
      requirement.requirements_list.requirement_weight_changed
    end
  end

  def after_destroy(requirement)
    requirement.requirements_list.requirement_weight_changed
  end
end
