require 'rake/testtask'
require 'active_record'
require 'rcov'

task :default => :test

Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/*_test.rb'
  test.verbose = true
end

desc "Migrate the database through scripts in db/migrate. Target specific version with VERSION=x"
task :migrate => :connect do
  ActiveRecord::Migrator.migrate('db/migrate', ENV["VERSION"] ? ENV["VERSION"].to_i : nil )
end

task :connect do
  ActiveRecord::Base.establish_connection(YAML::load(File.open("config/database.yml"))['production'])
  ActiveRecord::Base.logger = Logger.new(File.open('database.log', 'a'))
  
end

# this requires the RCOV gem to be installed on your system

desc "Generate code coverage with rcov"
task :rcov do
  rcov = %(rcov --text-summary -Ilib test/*_test.rb)
  system rcov
  system "open doc/coverage/index.html" if PLATFORM['darwin']
end


