require "test_helper"

class PlannerTest < Test::Unit::TestCase
  context "A planner" do
    setup do
      @p = Planner.new
    end
    should "be able to be created" do
      @p.inspect
    end    
  end
  
end