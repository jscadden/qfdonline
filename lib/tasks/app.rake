desc "run all tests"
task :all_tests do
 Rake::Task[:spec].invoke
 Rake::Task[:cucumber].invoke
 Rake::Task[:selenium].invoke
end
  
