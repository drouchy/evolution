defmodule Evolution.Swarm.AntColony.PheromonesTest do
  use ExUnit.Case, async: true
  use ExUnitProperties

  alias Evolution.Swarm.AntColony.{Pheromones, Trip}

  describe "initialise/1" do
    property "generate a random matrix size x size with values below 0.01" do
      check all size <- integer(2..10) do
        pheromones = Pheromones.initialise(size)

        assert Matrex.size(pheromones) == {size, size}
        assert Matrex.to_list(pheromones) |> Enum.all?(&(&1 <= 0.01))
      end
    end

    test "uses the random value generator from the settings" do
      values = [1, 0.2, 0.3, 0.1, 0.2, 0.3, 0.1, 0.3, 0.5]
      random = Evolution.Utils.FakeRandom.new(values: values)

      pheromones = Pheromones.initialise(3, random: random)

      assert Matrex.multiply(pheromones, 100) |> Enum.to_list() |> Enum.map(&(Float.round(&1, 1))) == values
    end
  end

  describe "update/2" do
    test "updates the pheromones based on the trip of the ant" do
      initial = Matrex.new("0.0 0.2 0.3; 0.01 0.0 0.03; 1 0.2 0.0")

      pheromones = Pheromones.update(initial, %Trip{path: [0, 2, 1], fitness: 4})

      assert Matrex.to_list(pheromones) |> Enum.map(&(Float.round(&1, 2))) == [
        0.00, 0.20, 0.55,
        0.26, 0.00, 0.03,
        1.00, 0.45, 0.00
      ]
    end

    test "updates the pheromones based on a colony of ants" do
      initial = Matrex.new("0.0 0.2 0.3; 0.01 0.0 0.03; 1 0.2 0.0")
      colony = [
        %Trip{path: [0, 2, 1], fitness: 4},
        %Trip{path: [1, 2, 0], fitness: 8},
        %Trip{path: [0, 1, 2], fitness: 2}
      ]

      pheromones = Pheromones.update(initial, colony)

      assert pheromones == Matrex.new("0.0 0.825 0.55; 0.26 0.0 0.655; 1.625 0.45 0.0")
    end
  end
end
