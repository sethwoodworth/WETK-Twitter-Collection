require "test_helper"


class PullerTest < Test::Unit::TestCase
  context "A puller" do
    setup do
      @p = Puller.new
    end
    should "be able to be created" do
      @p.inspect
    end    
  end
  
end