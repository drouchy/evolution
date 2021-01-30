defmodule Evolution.Utils.RandomTest do
  use ExUnit.Case, async: true
  
  describe "FakeRandom" do
    test "returns the pre expected values" do
      random = Evolution.Utils.FakeRandom.new(values: [1, 5, 4])
      
      assert random.(:does_not_matter) == 1
      assert random.(:does_not_matter) == 5
      assert random.(:does_not_matter) == 4
    end
    
    test "can build multiple randoms" do
      random_1 = Evolution.Utils.FakeRandom.new(values: [1, 5, 4])
      random_2 = Evolution.Utils.FakeRandom.new(values: [8, 1, 3])
      
      assert random_1.(:does_not_matter) == 1
      assert random_2.(:does_not_matter) == 8
      assert random_1.(:does_not_matter) == 5
      assert random_2.(:does_not_matter) == 1
      assert random_1.(:does_not_matter) == 4
      assert random_2.(:does_not_matter) == 3
    end
  end
end
