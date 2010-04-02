class RequirementObserver < ActiveRecord::Observer

  def after_save(requirement)
    if requirement.weight_changed?
      requirement.requirements_list.requirement_weight_changed
    end
  end
end
