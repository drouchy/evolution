defmodule Evolution.GeneticTest do
  use ExUnit.Case, async: true
  use ExUnitProperties

  @moduletag :full_test

  @problems [Evolution.Genetic.Problems.OneMax]

  alias Evolution.Genetic

  property "initialise/2 builds a population" do
    check all problem     <- one_of(@problems),
          population_size <- integer(1..100),
          problem_size    <- integer(1..1_000) do

      population = Genetic.initialise(problem, population_size: population_size, problem_size: problem_size)

      assert Enum.count(population.chromosomes) == population_size
      assert population.size                    == population_size

      assert Enum.all?(population.chromosomes, &(&1.size == problem_size))
      assert Enum.all?(population.chromosomes, &(&1.fitness >= 0))
    end
  end

  property "solve/2 solves the one_max problem" do
    check all population_size <- integer(20..50),
              problem_size    <- integer(5..15) do

      problem    = Genetic.Problems.OneMax
      population = Genetic.initialise(problem, population_size: population_size, problem_size: problem_size)

      solution   = Genetic.solve(problem, population)

      assert solution.generation                >= 0
      assert solution.champion.fitness         == problem_size
      assert Enum.sum(solution.champion.genes) == problem_size
    end
  end

  property "solve/2 solves the N Queens problem" do
    check all population_size <- integer(2..10),
              problem_size    <- integer(5..7) do

      problem = Genetic.Problems.NQueens

      population = Genetic.initialise(problem, population_size: population_size, problem_size: problem_size)
      solution   = Genetic.solve(problem, population,
        selection: &Evolution.Genetic.Toolbox.Selection.natural/2,
        crossover: &Evolution.Genetic.Toolbox.Crossover.order_one/3,
        re_insertion: &Evolution.Genetic.Toolbox.ReInsertion.elitist/4)

      assert solution.generation               >= 0
      assert length(solution.champion.genes)  == problem_size
      assert solution.champion.fitness        == problem_size
    end
  end

  @cities [
    %{lat: 35.6897,  lng: 139.6922},
    %{lat: -6.2146,  lng: 106.8451},
    %{lat: 28.6600,  lng: 77.2300},
    %{lat: 18.9667,  lng: 72.8333},
    %{lat: 14.5958,  lng: 120.9772},
    %{lat: 31.1667,  lng: 121.4667},
    %{lat: -23.5504, lng: -46.6339},
    %{lat: 37.5833,  lng: 127.0000},
    %{lat: 19.4333,	lng: -99.1333}
  ]
  property "solve/2 solves the traveling salesman problem" do
    check all population_size <- integer(2..10),
              problem_size    <- integer(5..7),
              iteration   <- integer(10..100) do
      cities = Enum.take_random(@cities, problem_size)
      problem = Genetic.Problems.TravelingSalesman

      population = Genetic.initialise(problem, population_size: population_size, problem_size: problem_size, cities: cities)
      solution   = Genetic.solve(problem, population,
        selection: &Evolution.Genetic.Toolbox.Selection.natural/2,
        crossover: &Evolution.Genetic.Toolbox.Crossover.order_one/3,
        re_insertion: &Evolution.Genetic.Toolbox.ReInsertion.elitist/4,
        cities: cities,
        max_iteration: iteration)

      assert solution.champion.fitness <= 0
    end
  end
end
