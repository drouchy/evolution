defmodule Evolution.Problems.NQueensTest do
  use ExUnit.Case, async: true
  use ExUnitProperties

  alias Evolution.Problems.NQueens

  property "genotype/1 generates a new chromosome with random positions for the queens" do
    check all size <- integer(3..10_000) do
      chromosome = NQueens.genotype(%{size: size})

      assert chromosome.size              == size
      assert Enum.count(chromosome.genes) == size
      assert chromosome.age               == 0
      assert Enum.sort(chromosome.genes)  == Enum.to_list(0..(size-1))
    end
  end

  describe "defaults/0" do
    test "sets the default strategies" do
      assert NQueens.defaults() == [selection: "natural", crossover: "order_one", mutation: "scramble", re_insertion: "pure"]
    end
  end

  describe "fitness/2" do
    @doc """
      the genes [2, 0, 3, 1] has a perfect fitness of 4
      ┌───┬───┬───┬───┐
      │   │ ◉ │   │   │
      ├───┼───┼───┼───┤
      │   │   │   │ ◉ │
      ├───┼───┼───┼───┤
      │ ◉ │   │   │   │
      ├───┼───┼───┼───┤
      │   │   │ ◉ │   │
      └───┴───┴───┴───┘
    """
    test "fitness is the length of genes when there is no conflict" do
      assert NQueens.fitness(%{genes: [2, 0, 3, 1], size: 4}, nil) == 4
    end

    @doc """
      the genes [2, 1, 3, 0] has 2 queens conflicting in diagonal
      ┌───┬───┬───┬───┐
      │   │   │   │ ◉ │
      ├───┼───┼───┼───┤
      │   │ ◉ │   │   │
      ├───┼───┼───┼───┤
      │ ◉ │   │   │   │
      ├───┼───┼───┼───┤
      │   │   │ ◉ │   │
      └───┴───┴───┴───┘
    """
    test "fitness calculates the size of the genes - the number of conflicts in diagonal" do
      assert NQueens.fitness(%{genes: [2, 1, 3, 0], size: 4}, nil) == 2
    end

    @doc """
      the worst possible solution [0, 1, 2, 3] as all queens are conflicting in diagonal
      ┌───┬───┬───┬───┐
      │ ◉ │   │   │   │
      ├───┼───┼───┼───┤
      │   │ ◉ │   │   │
      ├───┼───┼───┼───┤
      │   │   │ ◉ │   │
      ├───┼───┼───┼───┤
      │   │   │   │ ◉ │
      └───┴───┴───┴───┘
    """
    test "the worst possible solution has a negative fitness" do
      assert NQueens.fitness(%{genes: [0, 1, 2, 3], size: 4}, nil) == -8
    end
  end

  describe "terminate?/3" do
    test "checks the fitness of the chromosome" do
      assert NQueens.terminate?(%Evolution.Genetic.Chromosome{genes: [], size: 4, fitness: 4}, nil, nil)
      refute NQueens.terminate?(%Evolution.Genetic.Chromosome{genes: [], size: 4, fitness: 3}, nil, nil)
    end
  end

  describe "conflicts/2" do
    @doc """
      the genes [2, 0, 3, 1] does not have any conflict
      ┌───┬───┬───┬───┐
      │   │ ◉ │   │   │
      ├───┼───┼───┼───┤
      │   │   │   │ ◉ │
      ├───┼───┼───┼───┤
      │ ◉ │   │   │   │
      ├───┼───┼───┼───┤
      │   │   │ ◉ │   │
      └───┴───┴───┴───┘
    """
    test "returns an empty list when no conflict is detected" do
      assert Enum.empty? NQueens.conflicts(%{genes: [2, 0, 3, 1], size: 4})
    end

    @doc """
      the genes [0, 1, 2, 3] are all conflicting
      ┌───┬───┬───┬───┐
      │ ◉ │   │   │   │
      ├───┼───┼───┼───┤
      │   │ ◉ │   │   │
      ├───┼───┼───┼───┤
      │   │   │ ◉ │   │
      ├───┼───┼───┼───┤
      │   │   │   │ ◉ │
      └───┴───┴───┴───┘
    """
    test "returns all the genes when all are in conflict" do
      assert NQueens.conflicts(%{genes: [0, 1, 2, 3], size: 4}) == [0, 1, 2, 3]
    end

    @doc """
      the genes [2, 1, 3, 0] has 2 conflicts
      ┌───┬───┬───┬───┐
      │   │   │   │ ◉ │
      ├───┼───┼───┼───┤
      │   │ ◉ │   │   │
      ├───┼───┼───┼───┤
      │ ◉ │   │   │   │
      ├───┼───┼───┼───┤
      │   │   │ ◉ │   │
      └───┴───┴───┴───┘
    """
    test "returns only the genes in conflict" do
      assert NQueens.conflicts(%{genes: [2, 1, 3, 0], size: 4}) == [0, 1]
    end
  end
end
