defmodule Evolution.Genetic.Problems.OneMaxTest do
  use ExUnit.Case, async: true
  use ExUnitProperties

  alias Evolution.Genetic.Problems.OneMax

  property "genotype/1 generates a new chromosone with binarie genes of the desired size" do
    check all size <- integer(1..10_000) do
      chromosone = OneMax.genotype(%{size: size})

      assert chromosone.size              == size
      assert length(chromosone.genes)     == size
      assert Enum.sum(chromosone.genes)   <= size
      assert chromosone.age               == 0
      assert Enum.all?(chromosone.genes, &(&1 == 0 || &1 == 1))
    end
  end

  describe "defaults/0" do
    test "sets the default strategies" do
      assert OneMax.defaults() == [selection: "natural", crossover: "single_point", mutation: "scramble", re_insertion: "pure"]
    end
  end

  property "fitness/2 counts the number of 1 in the genes" do
    check all genes <- list_of(integer(0..1)) do
      chromosome = %Evolution.Genetic.Chromosome{genes: genes}

      assert OneMax.fitness(chromosome, %{}) >= 0
      assert OneMax.fitness(chromosome, %{}) <= Enum.count(genes)
      assert OneMax.fitness(chromosome, %{}) == genes |> Enum.filter(&(&1 == 1)) |> Enum.count()
    end
  end

  describe "terminate?/2" do
    test "terminates when the fittest chromosone has the fitness equal to the genes size" do
      chromosone = %Evolution.Genetic.Chromosome{genes: [1, 1, 1], fitness: 3, size: 3}

      assert OneMax.terminate?(chromosone, 0, %{})
    end

    test "does not terminate when the fittest chromosone has the fitness below the genes size" do
      chromosone = %Evolution.Genetic.Chromosome{genes: [1, 1, 0], fitness: 2, size: 3}

      refute OneMax.terminate?(chromosone, 0, %{})
    end
  end
end
