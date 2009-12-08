require 'rubygems'
require 'test/unit'
require 'fakeweb'
require 'shoulda'
require 'factory_girl'
require "#{File.dirname(__FILE__)}/schema"
require 'active_record'
require 'acts-as-taggable-on'
require 'twitter'
require "#{File.dirname(__FILE__)}/fakewebs"
require 'rr'




require "#{File.dirname(__FILE__)}/../lib/wetk_twitter"

class Test::Unit::TestCase
  include RR::Adapters::TestUnit
end












