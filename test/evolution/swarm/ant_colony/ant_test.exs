defmodule Evolution.Swarm.AntColony.AntTest do
  use ExUnit.Case, async: true
  use ExUnitProperties

  alias Evolution.Swarm.AntColony.Ant

  describe "travel/1" do
    property "travels to each index" do
      check all size <- integer(2..10),
                probabilities <- matrix_generator(size) do
        trip = Ant.traverse(probabilities)

        assert length(trip) == size
        assert Enum.sort(trip) == Enum.to_list(0..(size - 1))
      end
    end
  end

  def matrix_generator(size) do
    list_of(
      list_of(
        float(min: 0.1, max: 1.0),
        length: size),
      length: size
    )
  end
end
