defmodule Evolution.Genetic.Toolbox.ReInsertionTest do
  use ExUnit.Case, async: true
  use ExUnitProperties

  alias Evolution.Genetic.Toolbox.ReInsertion

  @problems [
    Evolution.Problems.OneMax,
  ]
  
  property "pure/4 only the offsprings are selected for re-insertion" do
    check all problem             <- one_of(@problems),
              size                <- integer(10..1_000),
              number_of_parents   <- integer(2..50 ), # usually the number of parents is the same than the numbers of offsprings
              number_of_leftovers <- integer(1..10) do
    
      parents    = Enum.map(1..number_of_parents,     fn _ -> problem.genotype(%{size: size}) end)
      offsprings = Enum.map(1..number_of_parents,     fn _ -> problem.genotype(%{size: size}) end)
      leftovers  = Enum.map(1..number_of_leftovers,   fn _ -> problem.genotype(%{size: size}) end)
      
      assert offsprings == ReInsertion.pure(parents, offsprings, leftovers, 1)
    end
  end
  
  property "elitist/4 selects the fittest of the previous generation and the offsprings" do
    check all problem             <- one_of(@problems),
              size                <- integer(10..1_000),
              survival_rate       <- float(min: 0, max: 1),
              number_of_parents   <- integer(2..50 ), # usually the number of parents is the same than the numbers of offsprings
              number_of_leftovers <- integer(1..10) do
          
      parents    = Enum.map(1..number_of_parents,     fn f -> problem.genotype(%{size: size, fitness: f}) end)
      leftovers  = Enum.map(1..number_of_leftovers,   fn f -> problem.genotype(%{size: size, fitness: f}) end)
      offsprings = Enum.map(1..number_of_parents,     fn _ -> problem.genotype(%{size: size}) end)
      
      next_generation = ReInsertion.elitist(parents, offsprings, leftovers, survival_rate: survival_rate)
      
      assert Enum.all?(offsprings, &(Enum.member?(next_generation, &1)))
      assert length(next_generation) == length(offsprings) + floor(length(parents ++ leftovers) * survival_rate)
    end
  end
end
