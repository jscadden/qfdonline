class RequirementsListObserver < ActiveRecord::Observer
  def after_create(requirements_list)
    requirements_list.requirements.create!(:name => "Example Requirement")
  end
end
