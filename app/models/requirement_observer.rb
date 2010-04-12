class RequirementObserver < ActiveRecord::Observer

  def after_create(requirement)
    if requirement.requested_position
      requirement.insert_at(requirement.requested_position)
    end
  end

  def after_save(requirement)
    if requirement.weight_changed?
      requirement.requirements_list.requirement_weight_changed
    end
  end

  def after_destroy(requirement)
    requirement.requirements_list.requirement_weight_changed
  end
end
