def disable_observers_for(instance)
  instance.stub(:notify)
end
