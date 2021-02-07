defmodule Evolution.Utils.RouletteWheelTest do
  use ExUnit.Case, async: true

  alias Evolution.Utils.RouletteWheel

  describe "spin/2" do
    test "returns the first element if that's the only value" do
      assert RouletteWheel.spin([1]) == 0
    end

    test "when the random number is below the first element, the value is 0" do
      random = Evolution.Utils.FakeRandom.new(values: [1])
      fitness = [3, 4, 2, 4] # [3, 7, *9*, 13]

      assert RouletteWheel.spin(fitness, random: random) == 0
    end

    test "returns the last index value where the sum is below the random number" do
      random = Evolution.Utils.FakeRandom.new(values: [8])
      fitness = [3, 4, 2, 4] # [3, 7, *9*, 13]

      assert RouletteWheel.spin(fitness, random: random) == 2
    end

    test "the fitness can be floats" do
      random = Evolution.Utils.FakeRandom.new(values: [8])
      fitness = [3.0, 4.0, 2.1, 4.3]

      assert RouletteWheel.spin(fitness, random: random) == 2
    end

    test "statistically the result are the ids with the largest value" do
      fitness = [10, 30, 40, 20]

      result = (1..1_000)
      |> Enum.map(fn _ -> RouletteWheel.spin(fitness) end)
      |> Enum.group_by(&Function.identity/1)
      |> Enum.reduce(%{}, fn {id, list} , acc -> Map.put(acc, id, length(list)) end)

      assert_in_delta result[0], 100, 20
      assert_in_delta result[1], 300, 60
      assert_in_delta result[2], 400, 80
      assert_in_delta result[3], 200, 40
    end
  end
end
