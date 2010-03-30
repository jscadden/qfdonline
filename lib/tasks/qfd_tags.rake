namespace :qfd do
  RUBY_FILES = FileList["**/*.rb"].exclude("pkg")

  desc "Generate a TAGS file for emacs"
  task :tags do 
    sh "ctags -e #{RUBY_FILES}", :verbose => false
  end
end
