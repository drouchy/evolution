defmodule Evolution.Genetic.MutationTest do
  use ExUnit.Case, async: true
  use ExUnitProperties

  alias Evolution.Genetic.Mutation
  alias Evolution.Genetic.Chromosome

  property "scramble/2 shuffle all the genes. So it keeps the same genes but move them around" do
    check all size  <- integer(100..10_000),
              genes <- list_of(integer(0..100), length: size) do
      initial = %Chromosome{size: size, genes: genes}

      mutant = Mutation.scramble(initial, [])

      assert mutant.genes            != initial.genes
      assert Enum.sort(mutant.genes) == Enum.sort(initial.genes)
      assert mutant.size             == initial.size
      assert mutant.age              == 0
    end
  end
end
