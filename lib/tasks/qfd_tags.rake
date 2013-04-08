namespace :qfd do
  JS_FILES = FileList["**/*.js"].exclude("pkg")
  RUBY_FILES = FileList["**/*.rb"].exclude("pkg")

  desc "Generate a TAGS file for emacs"
  task :tags do 
    sh "ctags -e #{RUBY_FILES} #{JS_FILES}", :verbose => false
  end
end
