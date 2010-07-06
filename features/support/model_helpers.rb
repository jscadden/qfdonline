module ModelHelpers

  %w( qfd hoq requirement user invitation ).each do |model|
    define_method("latest_#{model}") do
      model.classify.constantize.find(:first, :order => "created_at DESC") ||
        Factory(model)
    end
  end

end

World(ModelHelpers)
