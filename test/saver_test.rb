require "test_helper"

class SaverTest < Test::Unit::TestCase
  context "A saver" do
    setup do
      @s = Saver.new
    end
    should "be able to be created" do
      @s.inspect
    end    
  end
  
end