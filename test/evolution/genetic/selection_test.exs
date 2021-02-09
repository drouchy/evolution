defmodule Evolution.Genetic.SelectionTest do
  use ExUnit.Case, async: true

  alias Evolution.Genetic.Selection
  alias Evolution.Genetic.Chromosome

  describe "natural/2" do
    test "when selecting 100%, all the genes are selecting" do
      population = [
        %Chromosome{genes: [1, 0, 1], size: 3, fitness: 2},
        %Chromosome{genes: [1, 0, 0], size: 3, fitness: 1},
        %Chromosome{genes: [0, 1, 0], size: 3, fitness: 1},
        %Chromosome{genes: [0, 0, 0], size: 3, fitness: 0}
      ]

      assert {for_reproduction, []} = Selection.natural(population, ratio: 1)

      assert for_reproduction == [
          {
            %Chromosome{genes: [1, 0, 1], size: 3, fitness: 2},
            %Chromosome{genes: [1, 0, 0], size: 3, fitness: 1}
          },
          {
            %Chromosome{genes: [0, 1, 0], size: 3, fitness: 1},
            %Chromosome{genes: [0, 0, 0], size: 3, fitness: 0}
          }
      ]
    end

    test "when selecting 100%, there is one chromosome leftover when the population is odd" do
      population = [
        %Chromosome{genes: [1, 0, 1], size: 3, fitness: 2},
        %Chromosome{genes: [1, 0, 0], size: 3, fitness: 1},
        %Chromosome{genes: [0, 1, 0], size: 3, fitness: 1}
      ]

      assert {for_reproduction, [leftover]} = Selection.natural(population, ratio: 1)

      assert for_reproduction == [
        {
          %Chromosome{genes: [1, 0, 1], size: 3, fitness: 2},
          %Chromosome{genes: [1, 0, 0], size: 3, fitness: 1}
        }
      ]
      assert leftover == %Chromosome{genes: [0, 1, 0], size: 3, fitness: 1}
    end

    test "selecting a ratio takes only the fittest" do
      population = [
        %Chromosome{genes: [1, 0, 1], size: 3, fitness: 2},
        %Chromosome{genes: [1, 0, 0], size: 3, fitness: 1},
        %Chromosome{genes: [0, 1, 0], size: 3, fitness: 1},
        %Chromosome{genes: [0, 0, 0], size: 3, fitness: 0}
      ]

      assert {for_reproduction, leftovers} = Selection.natural(population, ratio: 0.5)

      assert for_reproduction == [
        {
          %Chromosome{genes: [1, 0, 1], size: 3, fitness: 2},
          %Chromosome{genes: [1, 0, 0], size: 3, fitness: 1}
        }
      ]

      assert leftovers == [
        %Chromosome{genes: [0, 1, 0], size: 3, fitness: 1},
        %Chromosome{genes: [0, 0, 0], size: 3, fitness: 0}
      ]
    end

    test "can not select when there is not enough in the population" do
      population = [
        %Chromosome{genes: [1, 0, 1], size: 3, fitness: 2}
      ]

      assert {[], leftovers} = Selection.natural(population, ratio: 0.5)

      assert leftovers == [%Chromosome{genes: [1, 0, 1], size: 3, fitness: 2}]
    end

    test "by default the ratio is 100% when not stated" do
      population = [
        %Chromosome{genes: [1, 0, 1], size: 3, fitness: 2},
        %Chromosome{genes: [1, 0, 0], size: 3, fitness: 1},
        %Chromosome{genes: [0, 1, 0], size: 3, fitness: 1},
        %Chromosome{genes: [0, 0, 0], size: 3, fitness: 0}
      ]

      assert {no_ratio,   []} = Selection.natural(population, something_else: 1)

      assert no_ratio == [
          {
            %Chromosome{genes: [1, 0, 1], size: 3, fitness: 2},
            %Chromosome{genes: [1, 0, 0], size: 3, fitness: 1}
          },
          {
            %Chromosome{genes: [0, 1, 0], size: 3, fitness: 1},
            %Chromosome{genes: [0, 0, 0], size: 3, fitness: 0}
          }
      ]
    end
  end
end
