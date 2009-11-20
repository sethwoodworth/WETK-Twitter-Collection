$: << File.expand_path(File.dirname(__FILE__) + "/lib")
require 'rubygems'
require 'activerecord'
require 'rubygems'
require 'acts-as-taggable-on'
require 'twitter'


ActiveRecord::Base.send :include, ActiveRecord::Acts::TaggableOn
ActiveRecord::Base.send :include, ActiveRecord::Acts::Tagger

setup_file = 'funrun_setup.yml'
setup = YAML::load(File.open(setup_file))

ActiveRecord::Base.establish_connection(YAML::load(File.open(setup_file))['db_connect'])
ActiveRecord::Base.logger = Logger.new(File.open('database.log', 'a'))


require 'wetk_twitter'


TwitterAccount.last