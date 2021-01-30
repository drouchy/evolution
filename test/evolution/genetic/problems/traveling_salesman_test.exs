defmodule Evolution.Genetic.Problems.TravelingSalesmanTest do
  use ExUnit.Case, async: true
  use ExUnitProperties

  alias Evolution.Genetic.Problems.TravelingSalesman

  alias Evolution.Genetic.Chromosome

  property "genotype/1 generates a new chromosome with random cities to visit" do
    check all size <- integer(3..10_000) do
      chromosome = TravelingSalesman.genotype(%{size: size})

      assert chromosome.size              == size
      assert Enum.count(chromosome.genes) == size
      assert chromosome.age               == 0
      assert Enum.sort(chromosome.genes)  == Enum.to_list(0..(size-1))
    end
  end

  @doc """

  to calculate the fitness [0, 1, 2], we calculate the sum of the distances between: [0, 1], [1, 2], [2, 0]

  as the problem requires to minimise the distance, the fitness is the opposite of the total distances

  ┌─────────────────────┐             ┌───────────────────────┐
  │(48.864716, 2.349014)│             │ (48.783333, 9.183333) │
  └─────────────────────┘             └───────────────────────┘
            .─.             ┌─────┐              .─.
           ( 0 )────────────┤500km├────────────▶( 1 )
            `─'             └─────┘              `─'
             ▲                                    │
             │                                    │
             │                                    │
             │                                 ┌──┴──┐
             │                                 │369km│
             │                                 └──┬──┘
             │                                    │
             │                                    │
             │                                    │
             │                                    ▼
             │              ┌─────┐              .─.
             └──────────────┤640km├─────────────( 2 )
                            └─────┘              `─'
                                      ┌──────────────────────┐
                                      │ (45.464664, 9.188540)│
                                      └──────────────────────┘

      in this example the fitness is -1 * (500 + 369 + 640) = -1,509
  """
  describe "fitness/2" do
    test "calculate the sum of the distances between each travel leg" do
      genes = [0, 1, 2]
      cities = [
        %{lat: 48.864716, lon: 2.349014},
        %{lat: 48.783333, lon: 9.183333},
        %{lat: 45.464664, lon: 9.188540}
      ]

      assert_in_delta TravelingSalesman.fitness(%Chromosome{genes: genes, size: 3}, cities: cities), -1_509_396, 1
    end
  end

  describe "terminate?/3" do
    test "terminates when the max generation is reached" do
      assert TravelingSalesman.terminate?(nil, 10_000, max_iteration: 10_000)
    end

    test "does not terminate when the max generation is not reached" do
      refute TravelingSalesman.terminate?(nil, 9_999, max_iteration: 10_000)
    end

    test "defaults the max_iteration to 10 000" do
      refute TravelingSalesman.terminate?(nil, 9_999, [])
      assert TravelingSalesman.terminate?(nil, 10_000, [])
    end
  end
end
