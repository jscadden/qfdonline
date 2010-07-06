require "timeout"

module ModelHelpers

  %w( qfd hoq requirement user invitation ).each do |model|
    define_method("latest_#{model}") do
      model.classify.constantize.find(:first, :order => "created_at DESC") ||
        Factory(model)
    end
  end

  def wait_for_new_requirement_to_be_created
    req_id = nil
    lambda do
      Timeout.timeout(Capybara.default_wait_time) do
        while req_id.blank?
          req_id = Requirement.maximum(:id, :conditions => ["name = ?", "New Requirement"])
          # slightly more effective than Thread.pass
          sleep 0.001 if req_id.blank?
        end
      end
    end.should_not raise_error, "Failed to find new requirement"
    req_id
  end

end

World(ModelHelpers)
