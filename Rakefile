require 'rake/testtask'
require 'activerecord'


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

end
