defmodule Evolution.Problems.NQueens do
  @behaviour Evolution.Genetic.Problem

  alias Evolution.Genetic.Chromosome

  @impl true
  def defaults(), do: [selection: "natural", crossover: "order_one", mutation: "scramble", re_insertion: "pure"]

  @impl true
  def genotype(%{size: size}) do
    genes = (0..size-1) |> Enum.to_list() |> Enum.shuffle()
    %Chromosome{genes: genes, size: size, fitness: -1}
  end

  @impl true
  def fitness(chromosome, _settings) do
    length(chromosome.genes) - length(analyse(chromosome))
  end

  def conflicts(chromosome) do
    chromosome
    |> analyse()
    |> Enum.uniq()
    |> Enum.sort()
  end

  defp analyse(chromosome) do
    max = chromosome.size - 1
    for i <- 0..max, j <- 0..max do
      if i != j do
        dx = abs(i - j)
        dy = abs(Enum.at(chromosome.genes, i) - Enum.at(chromosome.genes, j))
        if dx == dy do
          j
        else
          nil
        end
      else
        nil
      end
    end
    |> Enum.reject(&is_nil/1)
  end

  @impl true
  def terminate?(%Chromosome{size: size, fitness: fitness}, _iteration, _settings), do: fitness == size
end
