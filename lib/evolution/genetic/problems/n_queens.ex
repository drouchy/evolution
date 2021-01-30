defmodule Evolution.Genetic.Problems.NQueens do
  @behaviour Evolution.Genetic.Problem

  alias Evolution.Genetic.Chromosome

  @impl true
  def genotype(%{size: size}) do
    genes = (0..size-1) |> Enum.to_list() |> Enum.shuffle()
    %Chromosome{genes: genes, size: size, fitness: -1}
  end

  @impl true
  def fitness(chromosome, _settings) do
    max = chromosome.size - 1
    diag_clashes =
      for i <- 0..max, j <- 0..max do
        if i != j do
          dx = abs(i - j)
          dy = abs(Enum.at(chromosome.genes, i) - Enum.at(chromosome.genes, j))
          if dx == dy do
            1
          else
            0
          end
        else
          0
        end
      end
    length(Enum.uniq(chromosome.genes)) - Enum.sum(diag_clashes)
  end

  @impl true
  def terminate?(%Chromosome{size: size, fitness: fitness}, _iteration, _settings), do: fitness == size
end
