defmodule Evolution.Genetic.Toolbox.CrossoverTest do
  use ExUnit.Case, async: true
  use ExUnitProperties

  alias Evolution.Genetic.Toolbox.Crossover
  alias Evolution.Genetic.Chromosome

  alias Evolution.Genetic.Problems.OneMax, as: Problem

  describe "single_point/3" do
    test "crossing over swaps some part of the genes" do
      random = Evolution.Utils.FakeRandom.new(values: [1])
      
      parent_1 = %Chromosome{genes: [1, 2, 3], size: 3, age: 1}
      parent_2 = %Chromosome{genes: [0, 4, 5], size: 3, age: 4}

      [child_1, child_2] = Crossover.single_point(parent_1, parent_2, random: random)

      assert child_1.genes == [1, 4, 5]
      assert child_2.genes == [0, 2, 3]
    end

    property "single point crossover generates new chromosones with the same size" do
      check all size <- integer(10..100),
                split <- integer(1..size) do
        random = Evolution.Utils.FakeRandom.new(values: [split])
        
        parent_1 = Problem.genotype(%{size: size}) |> Map.put(:age, 1)
        parent_2 = Problem.genotype(%{size: size}) |> Map.put(:age, 2)

        [child_1, child_2] = Crossover.single_point(parent_1, parent_2, random: random)

        assert child_1.size == size
        assert child_2.size == size

        assert Enum.count(child_1.genes) == size
        assert Enum.count(child_2.genes) == size

        assert child_1.age == 0
        assert child_2.age == 0
      end
    end
  end
  
  describe "order_one" do
    property "all the chromosomes are valid" do
      check all size <- integer(10..100) do
        parent_1 = Evolution.Genetic.Problems.NQueens.genotype(%{size: size})
        parent_2 = Evolution.Genetic.Problems.NQueens.genotype(%{size: size})
        
        [child_1, child_2] = Crossover.order_one(parent_1, parent_2, [])
        
        assert child_1.size == size
        assert child_2.size == size
        
        assert Enum.sort(child_1.genes) == Enum.to_list(0..size-1)
        assert Enum.sort(child_2.genes) == Enum.to_list(0..size-1)
        
        assert child_1.age == 0
        assert child_2.age == 0
      end
    end
  end
end
