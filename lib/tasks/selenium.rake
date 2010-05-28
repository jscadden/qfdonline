require "fileutils"

desc "Run selenium tasks"
task :selenium do
  sh %{script/cucumber -p selenium features/enhanced}
end
